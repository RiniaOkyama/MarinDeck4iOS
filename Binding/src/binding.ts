export interface MarinDeckBindingsInterface {
    openSettings(): void
    alert(text: string): void
    openUrl(url: string): void
}

export class MarinDeckBindings implements MarinDeckBindingsInterface {
    openSettings() {
        window.MD.Native.post({
            type: 'openSettings',
            body: { value: true }
        })
    }

    alert(text: string): void {
        window.MD.Native.post({
            type: "presentAlert",
            body: { text: text }
        })
    }

    openUrl(url: string): void {
        window.MD.Native.post({
            type: "openUrl",
            body: { url: url }
        })
    }
}