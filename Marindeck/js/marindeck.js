document.body.style.backgroundColor = "#15202b";
// select 禁止
document.documentElement.style.webkitUserSelect = 'none';
// menu 禁止
document.documentElement.style.webkitTouchCallout = 'none';

// Zoom禁止
const viewport = document.querySelector('meta[name=viewport]')
if (viewport) {
    viewport.content += ',maximum-scale=1'
}

//const moduleRaid = require('./moduleraid');
let mR = moduleRaid();
// Grab TweetDeck's jQuery from webpack
var jq = mR && mR.findFunction('jQuery') && mR.findFunction('jquery:')[0];

// ロード後に走るので、検証したい場合はwindow.onload等を使えください。
const sleep = msec => new Promise(resolve => setTimeout(resolve, msec));
(async () => {
    await sleep(800);

    swiftLog("window onload");
    swiftLog("try didLoad");
    try {
        webkit.messageHandlers.jsCallbackHandler.postMessage("didLoad");
        webkit.messageHandlers.viewDidLoad.postMessage(true);
    } catch (e) {
        swiftLog("ERROR! viewDidLoad Faild " + String(e));
    }
    try {
        loginStyled();
        swiftLog("login style changed");
    } catch (e) {
        swiftLog("login load error" + String(e));
    }

    // 画像のモーダルを抹殺
    new MutationObserver((records) => {
        return [...records || []].forEach((record) => {
            const target = record.target
            if (target instanceof HTMLElement) {
                const isOpenModal = target.id === 'open-modal'
                if (isOpenModal) {
                    const mediatable = target.querySelector('.js-mediatable')
                    const dismiss = target.querySelector('.js-dismiss')
                    const isVideo = target.getElementsByTagName('video').length > 0
                    console.log(isVideo)
                    if (!isVideo) {
                        if (mediatable && dismiss) dismiss.click()
                    }
                }
            }
        })
    }).observe(document.body, {childList: true, subtree: true})

})();


// カラムのスクロール。 Menu開くときにカラムと一緒に動かなくするため。
// const columnScroll = {
//   style: null,
//   init: () => {
//     if (!columnScroll.style) {
//       columnScroll.style = document.createElement('style')
//       document.head.insertAdjacentElement('beforeend', columnScroll.style)
//     }
//     columnScroll.style.textContent = ''
//   },
//   on: () => {
//     columnScroll.init()
//     columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:auto!important}')
//   },
//   off: () => {
//     columnScroll.init()
//     columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:hidden!important}')
//   }
// }

// document.addEventListener('touchstart', (e) => {
//   if (e.touches[0].clientX <= 8) {
//     columnScroll.off()
//   } else {
//     columnScroll.on()
//   }
// }, { passive: true })


function isTweetButtonHidden(bool) {
    webkit.messageHandlers.isTweetButtonHidden.postMessage(bool);
}


function loginStyled() {
    document.querySelector(".startflow-background").hidden = true;
    document.querySelector(".startflow-background").style.backgroundColor = "#252525";
    
    document.querySelector(".app-info-panel").style.margin = "92px auto";
    document.querySelector(".login-container").style.minHeight = "0px";

    document.querySelector(".app-info-title").innerText = "MarinDeckへようこそ";
    document.querySelector(".app-info-title").style.fontSize = "22px"
    document.querySelector(".app-info-text p").innerText = "廃人への第一歩、そしてその先へ";
    
    document.querySelectorAll(".js-startflow-chrome")[1].hidden = true
    document.querySelector(".js-login-form").style.backgroundColor = "rgb(30,41,55)";
    document.querySelector(".js-login-form").border = null;
    
    document.querySelector("#login-form-title").innerText = "Twitterアカウントでログイン";
    document.querySelector("#login-form-title").style.fontSize = "16px";
    document.querySelector(".js-login-form .Button").innerText = "ログイン";
    document.querySelector("#login-form-title").style.color = "white";

    // ログイン透明化
    document.querySelector(".js-login-form").style.backgroundColor = "transparent";
    // ログインボーダー
    document.querySelector(".js-login-form").style.borderStyle = "none";
    document.querySelector("#login-form-title").style.borderStyle = "none";
    document.querySelector(".divider-bar").style.display = "none";

    document.querySelector(".js-signin-ui").style.margin = "10% auto";
    document.querySelector(".js-signin-ui").style.width = "98%";

    // login btn
    document.querySelector(".js-login-form .Button").style.padding = "13px";

    //tweetdeck icon
    document.querySelector(".sprite-logo").remove();
    
    document.querySelector(".app-info-text").style.textAlign = "center"
    document.querySelector(".app-info-text").style.width = "100%"

    document.querySelectorAll(".app-signin-wrap")[1].style.width = null
    document.querySelector(".js-signin-ui .Button").style.borderRadius = "6px"
    document.querySelector(".js-signin-ui .Button").style.outline = "none"
    
    document.querySelectorAll(".app-signin-wrap")[1].style.width = "100%";
    
    isTweetButtonHidden(true)
}

///////////////////////////////////////

function addTweetImage(base64, type, name) {
    var bin = atob(base64.replace(/^.*,/, '')); // decode base64
    var buffer = new Uint8Array(bin.length); // to binary data
    for (var i = 0; i < bin.length; i++) {
        buffer[i] = bin.charCodeAt(i);
    }
    const imgFile = new File([buffer.buffer], name, {type: type});

    jq(document).trigger("uiFilesAdded", {files: [imgFile]});
}

function swiftLog(...msg) {
    console.log("JS Log:", msg)
    webkit.messageHandlers.jsCallbackHandler.postMessage(msg);
}

function openSettings() {
    webkit.messageHandlers.openSettings.postMessage(true);
}

function touchPointTweetLike(x, y) {
    document.elementFromPoint(x, y).closest(".tweet").getElementsByClassName("tweet-action")[2].click();
}

function positionElement(x, y) {
    webkit.messageHandlers.jsCallbackHandler.postMessage("CALLED position element");
    const element = document.elementFromPoint(x, y);
    console.log(element);
    webkit.messageHandlers.jsCallbackHandler.postMessage(String(element.style.backgroundImage));

    if (!element.classList.contains("js-media-image-link") && !element.classList.contains("media-img")) {
        console.log(element.classList)
        return
    }

    let openImgNum = 0
    let imgUrls = []
    element.parentElement.parentElement.querySelectorAll(".js-media-image-link").forEach(function (item, index) {
        const img = item.style.backgroundImage
        if (img === "") {
            imgUrls.push(item.querySelector("img").src);
        } else {
            imgUrls.push(img);
        }
        if (item === element) {
            openImgNum = index;
            swiftLog("openImgNum", index);
        }
    })

    var rect = element.getBoundingClientRect();
    console.log(rect);
    webkit.messageHandlers.imageViewPos.postMessage([rect.left, rect.top, rect.width, rect.height]);
    // webkit.messageHandlers.imagePreviewer.postMessage(imgUrls);
    return [openImgNum, imgUrls]
}

function triggerEvent(element, event) {
    if (document.createEvent) {
        // IE以外
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent(event, true, true); // event type, bubbling, cancelable
        return element.dispatchEvent(evt);
    } else {
        // IE
        var evt = document.createEventObject();
        return element.fireEvent("on" + event, evt);
    }
}

(async () => {
    let endedlist = []

    new MutationObserver(records => {
        document.querySelectorAll(".js-media-image-link").forEach(function (image) {
            if (endedlist.indexOf(image) === -1) {
                endedlist.push(image);

                if (image.parentElement.classList.contains("is-video")) {
                    // image.addEventListener("click", function (clickedItem) {
                    //     swiftLog("isVideo onClick")
                    // })
                    if (image.href.includes("youtube.com")) {
                        image.addEventListener("click", function (clickedItem) {
                            const url = clickedItem.target.href
                            webkit.messageHandlers.openYoutube.postMessage(url);
                        })
                    }
                    
                } else {
                    image.addEventListener("click", function (clickedItem) {
                        swiftLog("image onClick")
                        const res = positionElement(clickedItem.x, clickedItem.y);
                        webkit.messageHandlers.imagePreviewer.postMessage(res);
                    });
                }
            }
        });
    }).observe(document.body, {childList: true, subtree: true})


    // while (true) {
    //     await sleep(1000);
    //
    //     document.querySelectorAll(".js-media-image-link").forEach(function (image) {
    //         if (endedlist.indexOf(image) >= 0) {
    //
    //         } else {
    //             if (image.parentElement.classList.contains("is-video")) {
    //                 image.addEventListener("click", function (clickedItem) {
    //                     swiftLog("isVideo onClick")
    //                 })
    //             } else {
    //                 endedlist.push(image);
    //                 image.addEventListener("click", function (clickedItem) {
    //                     swiftLog("image onClick")
    //                     const res = positionElement(clickedItem.x, clickedItem.y);
    //                     webkit.messageHandlers.imagePreviewer.postMessage(res);
    //                 });
    //             }
    //         }
    //     });
    // }
})();


/** tweet */
const getClient = (key = null) => TD.controller.clients.getClient(key || TD.storage.accountController.getDefault().privateState.key) || TD.controller.clients.getPreferredClient('twitter')

const getAllAccounts = () => {
    const accounts = []
    TD.storage.accountController.getAll().forEach((x) => {
        if (x.managed) accounts.push({
            key: x.privateState.key,
            name: x.state.name,
            userId: x.state.userId,
            username: x.state.username,
            profileImageURL: x.state.profileImageURL,
        })
    })
    return accounts
}

const postTweet = (text, reply_to_id = null, key = null) => {
    new Promise((resolve, reject) => {
        getClient(key).update(text, reply_to_id, null, null, null, resolve, reject)
    })
    return "Done"
}
