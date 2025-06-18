const { app, BrowserWindow, dialog, ipcMain } = require('electron');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

app.commandLine.appendSwitch('js-flags', '--max-old-space-size=8192'); // 8GB

let rProcess = null;

function deleteTempFolders(machFolder = null) {
  try {
    // Clean basin_files
    const basinFilesPath = path.join(__dirname, 'basin_files');
    if (fs.existsSync(basinFilesPath)) {
      for (let i = 0; i < 5; i++) {
        try {
          fs.rmSync(basinFilesPath, { recursive: true, force: true });
          console.log('Deleted basin_files folder');
          break;
        } catch (err) {
          console.log(`Attempt ${i + 1} to delete basin_files failed: ${err.message}`);
          if (i < 4) require('child_process').execSync('timeout /t 2');
        }
      }
      if (fs.existsSync(basinFilesPath)) {
        console.error('Failed to delete basin_files after retries');
      }
    }

    // Clean qs_cache_temp
    if (machFolder && fs.existsSync(machFolder)) {
      const qsCachePath = path.join(machFolder, 'qs_cache_temp');
      if (fs.existsSync(qsCachePath)) {
        for (let i = 0; i < 5; i++) {
          try {
            fs.rmSync(qsCachePath, { recursive: true, force: true });
            console.log('Deleted qs_cache_temp folder');
            break;
          } catch (err) {
            console.log(`Attempt ${i + 1} to delete qs_cache_temp failed: ${err.message}`);
            if (i < 4) require('child_process').execSync('timeout /t 2');
          }
        }
        if (fs.existsSync(qsCachePath)) {
          console.error('Failed to delete qs_cache_temp after retries');
        }
      }
    }
  } catch (err) {
    console.error('Error deleting temp folders:', err);
  }
}

function killRProcess() {
  if (rProcess) {
    try {
      rProcess.kill('SIGTERM');
      setTimeout(() => {
        if (!rProcess.killed) {
          rProcess.kill('SIGKILL');
          console.log('Force killed R process');
        }
      }, 1000);
      exec('taskkill /IM Rscript.exe /F', (err) => {
        if (err) console.error('taskkill error:', err);
        else console.log('Terminated Rscript.exe');
      });
      rProcess = null;
    } catch (err) {
      console.error('Error killing R process:', err);
    }
  }
}

function createWindow() {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    }
  });

  win.webContents.openDevTools();

  const rPath = path.join(__dirname, '..', 'R', 'bin', 'x64', 'Rscript.exe');
  const tempRunAppPath = path.join(__dirname, 'temp_run_app.R');
  const command = `"${rPath}" "${tempRunAppPath}"`;

  rProcess = exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    console.log('R stdout:', stdout);
    if (stderr) console.error('R stderr:', stderr);
  });

  let port = null;
  async function tryLoadURL(url, retries = 10, delay = 2000) {
    for (let i = 0; i < retries; i++) {
      try {
        await win.loadURL(url);
        console.log(`Successfully loaded ${url}`);
        return;
      } catch (err) {
        console.log(`Attempt ${i + 1}/${retries} failed: ${err.message}`);
        if (i < retries - 1) {
          await new Promise(resolve => setTimeout(resolve, delay));
        }
      }
    }
    console.error(`Failed to load ${url} after ${retries} attempts.`);
  }

  rProcess.stdout.on('data', (data) => {
    const output = data.toString();
    console.log('R Output:', output);

    let portMatch = output.match(/Using port: (\d+)/);
    if (portMatch) {
      port = portMatch[1];
      console.log(`Detected port: ${port}`);
      tryLoadURL(`http://localhost:${port}`);
    }
  });

  setTimeout(() => {
    if (!port) {
      console.error('No port detected after 20 seconds. Check R script.');
    }
  }, 20000);

  win.on('closed', () => {
    killRProcess();
    deleteTempFolders(global.machFolder);
    app.quit();
  });
}

ipcMain.handle('select-folder-mach', async () => {
  const result = await dialog.showOpenDialog({
    properties: ['openDirectory']
  });
  if (!result.canceled && result.filePaths[0]) {
    global.machFolder = result.filePaths[0];
    return result.filePaths[0];
  }
  return null;
});

ipcMain.handle('select-folder-mopex', async () => {
  const result = await dialog.showOpenDialog({
    properties: ['openDirectory']
  });
  return result.canceled ? null : result.filePaths[0];
});

app.whenReady().then(() => {
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  killRProcess();
  deleteTempFolders(global.machFolder);
  if (process.platform !== 'darwin') app.quit();
});

app.on('before-quit', () => {
  killRProcess();
  deleteTempFolders(global.machFolder);
});
