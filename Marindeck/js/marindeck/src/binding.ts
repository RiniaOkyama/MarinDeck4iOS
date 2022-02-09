interface Window {
    webkit?: any;
}

declare var window: Window;



export function openSettings() {
    window.webkit.messageHandlers.openSettings.postMessage(true)
}