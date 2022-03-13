import { jQuery } from "../MarinDeckObject/src/objects/jQuery"

export interface MarinDeckInputsInterface {
    addTweetImage(base64: string, type: string, name: string): void
    touchPointTweetLike(x: number, y: number): void
}

export class MarinDeckInputs implements MarinDeckInputsInterface {
    
    addTweetImage(base64: string, type: string, name: string) {
        var bin = atob(base64.replace(/^.*,/, '')); // decode base64
        var buffer = new Uint8Array(bin.length); // to binary data
        for (var i = 0; i < bin.length; i++) {
            buffer[i] = bin.charCodeAt(i);
        }
        const imgFile = new File([buffer.buffer], name, {type: type});
    
        jQuery(document).trigger("uiFilesAdded", {files: [imgFile]});
    }

    touchPointTweetLike(x: number, y: number) {
        const element = document.elementFromPoint(x, y)?.closest(".tweet")?.getElementsByClassName("tweet-action")[2]
        if (element instanceof HTMLElement) {
            element.click()
        }
    }
}