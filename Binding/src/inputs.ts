import { jQuery } from "../MarinDeckObject/src/objects/jQuery"


export interface MarinDeckInputsInterface {
    addTweetImage(base64: string, type: string, name: string): void
    touchPointTweetLike(x: number, y: number): void
    postTweet(text: string, reply_to_id, key): void
}

/** tweet */
// const getClient = (key = null) => window.TD.controller.clients.getClient(key || window.TD.storage.accountController.getDefault().privateState.key) || window.TD.controller.clients.getPreferredClient('twitter')

// const getAllAccounts = () => {
//     const accounts = []
//     window.TD.storage.accountController.getAll().forEach((x) => {
//         if (x.managed) accounts.push({
//             key: x.privateState.key,
//             name: x.state.name,
//             userId: x.state.userId,
//             username: x.state.username,
//             profileImageURL: x.state.profileImageURL,
//         })
//     })
//     return accounts
// }

// window.TD.storage.accountController.getAll()
//     .filter(({managed}) => managed)
//     .map(({state: {name: fullname, username, userId, profileImageURL}}) => ({fullname, username, userId, profileImageURL}))


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

    postTweet(text: string) {
        window.MD.TwitterAPI.update({
            status: text,
            from: window.TD.storage.accountController.getDefault().getUsername()
        })
            // getClient(key).update(text, reply_to_id, null, null, null, resolve, reject)
    }
}