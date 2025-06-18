const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("electronAPI", {
  selectFolderMach: async () => {
    return await ipcRenderer.invoke("select-folder-mach");
  },
  selectFolderMopex: async () => {
    return await ipcRenderer.invoke("select-folder-mopex");
  },
 
});
