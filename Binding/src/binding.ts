export interface MarinDeckBindingsInterface {
    openSettings(): void
}

export class MarinDeckBindings {
    openSettings() {
        window.MD.Native.post({
            type: 'openSettings',
            body: { value: true }
        })
    }
}