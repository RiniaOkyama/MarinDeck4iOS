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

const sleep = msec => new Promise(resolve => setTimeout(resolve, msec));
(async () => {
    await sleep(800);

    swiftLog("window onload");
    swiftLog("try didLoad");
    try {
        // webkit.messageHandlers.jsCallbackHandler.postMessage("didLoad");
        window.MD.Native.post({
            type: 'viewDidLoad',
            body: {}
        })
    } catch (e) {
        swiftLog("ERROR! viewDidLoad Faild " + String(e));
    }
    try {
        loginStyled();
        swiftLog("login style changed");
    } catch (e) {
        swiftLog("login load error" + String(e));
    }

    const isNativeImageModal = await window.MD.Native.get({
        type: "config",
        body: {
            action: "get",
            key: "isNativeImageModal"
        }
    })

    if (isNativeImageModal || isNativeImageModal == null) {
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

                    const video = target.querySelector("video")
                    if (video !== null) {
                        const isGif = video.classList.contains("js-media-gif")
                        if (isGif) {
                            // video.removeAttribute("loop")
                            video.setAttribute("controls", "")
                            video.setAttribute("playsinline", "")
                            video.setAttribute("webkit-playsinline", "")
                            const cl = video.classList.value
                            video.classList.value = "-"
                            window.setTimeout(function () {
                                video.classList.value = cl
                            }, 1);
                            // video.setAttribute("autoplay", "")
                            // video.removeAttribute("autoplay")
                        }
                    }
                }
            })
        }).observe(document.body, {
            childList: true,
            subtree: true
        })
    }

})();

function isTweetButtonHidden(bool) {
    window.MD.Native.post({
        type: 'isTweetButtonHidden',
        body: {
            value: bool
        }
    })
}


function loginStyled() {
    document.querySelector(".startflow-background").hidden = true;
    document.querySelector(".startflow-background").style.backgroundColor = "#252525";

    document.querySelector(".app-info-panel").style.margin = "92px auto";
    document.querySelector(".login-container").style.minHeight = "0px";

    document.querySelector(".app-info-title").innerText = "MarinDeckへようこそ";
    document.querySelector(".app-info-title").style.fontSize = "22px"
    document.querySelector(".app-info-text p").innerText = "";

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

    document.querySelector(".startflow-link").removeAttribute("target");

    isTweetButtonHidden(true)
}

///////////////////////////////////////


function swiftLog(...msg) {
    console.log("JS Log:", msg)

    window.MD.Native.post({
        type: 'jsCallbackHandler',
        body: {
            value: msg
        }
    })
}

// TODO: 関数名が超絶わかりにくいので修正
// x, yに画像があれば取ってくる処理 return: 選択されたIndex, 画像urls
function positionElement(x, y) {
    swiftLog("CALLED position element");
    const element = document.elementFromPoint(x, y);
    console.log(element);
    swiftLog(String(element.style.backgroundImage));

    if (!element.classList.contains("js-media-image-link") && !element.classList.contains("media-img")) {
        console.log(element.classList)
        return
    }

    let imgUrls = []
    let selectIndex = 0
    let positions = []
    element.parentElement.parentElement.querySelectorAll(".js-media-image-link").forEach(function (item, index) {
        if (item === element) {
            selectIndex = index

            //            const obj = item.querySelector("img")
            //           
            //            var cvs = document.createElement('canvas');
            //            cvs.width  = obj.width;
            //            cvs.height = obj.height;
            //            var ctx = cvs.getContext('2d');
            //            ctx.drawImage(obj, 0, 0);
            //           
            //            const data = cvs.toDataURL("image/png");
            //            webkit.messageHandlers.selectedImageBase64.postMessage(data);

        }
        const img = item.style.backgroundImage
        if (img === "") {
            imgUrls.push(item.querySelector("img").src);
        } else {
            imgUrls.push(img);
        }

        const rect = item.getBoundingClientRect()
        positions.push([rect.left, rect.top, rect.width, rect.height])
    })

    //    var rect = element.getBoundingClientRect();
    //    console.log(rect);
    /* Ex
            ([
             [left, right, width, height],
             [left, right, width, height],
             [left, right, width, height]
            ], selectIndex)
     */

    window.MD.Native.post({
        type: 'imageViewPos',
        body: {
            positions: positions
        }
    })

    return [selectIndex, imgUrls]
}

(async () => {
    await sleep(800);

    let endedlist = []
    let subscribedActionUrls = []

    const isNativeImageModal = await window.MD.Native.get({
        type: "config",
        body: {
            action: "get",
            key: "isNativeImageModal"
        }
    })

    new MutationObserver(_ => {
        document.querySelectorAll(".js-media-image-link").forEach(function (image) {
            if (endedlist.indexOf(image) === -1) {
                endedlist.push(image);

                if (image.parentElement.classList.contains("is-video")) {
                    if (image.href.includes("youtube.com")) {
                        image.addEventListener("click", function (clickedItem) {
                            const url = clickedItem.target.href
                            window.MD.Native.post({
                                type: 'openYoutube',
                                body: {
                                    url: url
                                }
                            })
                        })
                    }

                } else {
                    if (isNativeImageModal || isNativeImageModal == null) {
                        image.addEventListener("click", function (clickedItem) {
                            swiftLog("image onClick")
                            const res = positionElement(clickedItem.x, clickedItem.y);

                            window.MD.Native.post({
                                type: 'imagePreviewer',
                                body: {
                                    selectedIndex: res[0],
                                    imageUrls: res[1]
                                }
                            })
                        })
                    }
                }
            }
        });

        // FIXME: Array.from
        Array.from(document.getElementsByClassName("js-action-url")).forEach((element) => {
            if (!subscribedActionUrls.includes(element.href)) {
                subscribedActionUrls.push(element.href);
                console.log("subscribed", element.href)
                element.addEventListener("click", e => {
                    window.Bindings.openUrl(e.currentTarget.href);
                })
            }
        })
    }).observe(document.body, {
        childList: true,
        subtree: true
    })
})();