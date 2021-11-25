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

window.MD = window.MD || {};
window.MD.msecdeck = {
  formatToken: 'YYYY/MM/DD HH:mm:ss.SSS',
  formatTokenShort: 'HH:mm.ss.SSS',
  options: 'ja', // 'ja' or 'en' or {...obj}
};


/*! TypeScript MsecDeck by taiy */(()=>{"use strict";var e={541:(e,t,r)=>{var a=r(89);Date.prototype.format=function(e,t){const r=e=>{const t=Object.prototype.toString.call(e).slice(8,-1).toLowerCase();if("number"===t){const t=e;if(Number.isNaN(t))return"NaN";if(!Number.isFinite(t))return"Infinity"}return t},o=e=>!!e&&"object"===r(e),s=e=>o(e)?e:{},n=e=>"string"===r(e);if(!n(e))throw new SyntaxError("引数format は、型 'string' である必要があります。");const i=n(t)?t.toLowerCase().split("-")[0]:"en";if(n(t)&&(t={}),!o(t))throw new SyntaxError("引数options は、型 'object' または 'string' である必要があります。");const c=(e,t)=>{const r=Number(e);if(Number.isNaN(r)||!t)return e.toString();return(-1===Math.sign(r)?"-":"")+r.toString().padStart(t,"0")},m={en:{months:["January","February","March","April","May","June","July","August","September","October","November","December"],monthsShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],weekdays:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],weekdaysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],meridiem:["AM","PM"],meridiemLowercase:["am","pm"]},ja:{months:["1","2","3","4","5","6","7","8","9","10","11","12"],monthsShort:["1","2","3","4","5","6","7","8","9","10","11","12"],weekdays:["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"],weekdaysShort:["日","月","火","水","木","金","土"],meridiem:["午前","午後"],meridiemLowercase:["午前","午後"]}},l={ja:{longEra:new Intl.DateTimeFormat("ja-JP-u-ca-japanese",{era:"long",year:"numeric"}),narrowEra:new Intl.DateTimeFormat("ja-JP-u-ca-japanese",{era:"narrow",year:"numeric"}),getEra:e=>e.filter((e=>"era"===e.type))[0].value,getYear:e=>{const t=e.filter((e=>"year"===e.type))[0].value;return"元"===t?"1":t},getLong:e=>{const t=l.ja.longEra.formatToParts(e),r=l.ja.getEra(t),a=l.ja.getYear(t),o=["-","0"].includes(a.slice(0,1))||e.getFullYear()<645,s=e.getFullYear()<=0;return{era:s?"紀元前":o?"西暦":r,year:s?c(Math.abs(e.getFullYear())+1,0):o?c(e.getFullYear(),0):a,isAD:o,isBC:s}},getNarrow:e=>{const t=l.ja.narrowEra.formatToParts(e),r=l.ja.getEra(t),a=l.ja.getYear(t),o=["-","0"].includes(a.slice(0,1))||e.getFullYear()<645,s=e.getFullYear()<=0;return{era:s?"BC":o?"AD":r,year:s?c(Math.abs(e.getFullYear())+1,0):o?c(e.getFullYear(),0):a,isAD:o,isBC:s}}}},u={locale:(0,a.v)(s(m.en),s(m[i]),!1),format:{YYYY:e=>c(e.getFullYear(),4),YY:e=>c(e.getFullYear(),0).slice(-2),Y:e=>c(e.getFullYear(),4),Mo:e=>c(e.getMonth(),0)+([null,"st","nd","rd"][e.getMonth()%100>>3^1&&e.getMonth()%10]||"th"),MMMM:(e,t)=>t.locale.months[e.getMonth()],MMM:(e,t)=>t.locale.monthsShort[e.getMonth()],MM:e=>c(e.getMonth()+1,2),M:e=>c(e.getMonth()+1,0),Do:e=>c(e.getDate(),0)+([null,"st","nd","rd"][e.getDate()%100>>3^1&&e.getDate()%10]||"th"),DD:e=>c(e.getDate(),2),D:e=>c(e.getDate(),0),HH:e=>c(e.getHours(),2),H:e=>c(e.getHours(),0),hh:e=>c(e.getHours()%12||12,2),h:e=>c(e.getHours()%12||12,0),kk:e=>c(e.getHours()||24,2),k:e=>c(e.getHours()||24,0),mm:e=>c(e.getMinutes(),2),m:e=>c(e.getMinutes(),0),ss:e=>c(e.getSeconds(),2),s:e=>c(e.getSeconds(),0),SSS:e=>c(e.getMilliseconds(),3),SS:e=>c(e.getMilliseconds(),3).slice(0,2),S:e=>c(e.getMilliseconds(),3).slice(0,1),A:(e,t)=>t.locale.meridiem[e.getHours()<12?0:1],a:(e,t)=>t.locale.meridiemLowercase[e.getHours()<12?0:1],dddd:(e,t)=>t.locale.weekdays[e.getDay()],ddd:(e,t)=>t.locale.weekdaysShort[e.getDay()],NNNNN:e=>{const{era:t}=l.ja.getNarrow(e);return{M:"㍾",T:"㍽",S:"㍼",H:"㍻",R:"㋿"}[t]||t},NNNN:e=>{const{era:t}=l.ja.getLong(e);return t},NNN:e=>{const{era:t}=l.ja.getNarrow(e);return t},NN:e=>{const{era:t}=l.ja.getNarrow(e);return t},N:e=>{const{era:t}=l.ja.getNarrow(e);return t},yo:e=>{const{year:t,isAD:r,isBC:a}=l.ja.getNarrow(e);return(r||a||"1"!==t?t:"元")+"年"},yyyy:e=>{const{year:t}=l.ja.getNarrow(e);return c(t,4)},yyy:e=>{const{year:t}=l.ja.getNarrow(e);return c(t,3)},yy:e=>{const{year:t}=l.ja.getNarrow(e);return c(t,2)},y:e=>{const{year:t}=l.ja.getNarrow(e);return t},ZZ:e=>{const t=e.getTimezoneOffset();return`${1===Math.sign(t)||0===Math.sign(t)?"-":"+"}${c(Math.abs(t)/60|0,2)}${c(Math.abs(t)%60|0,2)}`},Z:e=>{const t=e.getTimezoneOffset();return`${1===Math.sign(t)||0===Math.sign(t)?"-":"+"}${c(Math.abs(t)/60|0,2)}:${c(Math.abs(t)%60|0,2)}`},X:e=>c(e.getTime()/1e3|0,0),x:e=>c(e.getTime(),0)}},d={...t},g=(0,a.v)(u,d,!1),w=Object.keys(s(g.format)).sort().sort(((e,t)=>([e,t]=[e.toUpperCase(),t.toUpperCase()],e.length>t.length?-1:e.length<t.length||e>t?1:e<t?-1:0))).reduce(((e,t)=>{const r=t.replace(/([\\\*\.\+\?\|\{\}\(\)\[\]\^\$])/g,"\\$1");return e?e+"|"+r:r}),""),h=new RegExp(`(\\[[^\\[]*\\])|(\\\\)?(${w}|.)`,"g");return[...e.match(h)||[]].map((e=>{const t=s(g.format)[e];if("function"==typeof t){return t(this,g)}return/^\[[^\[]*\]$/.test(e)?e.slice(1,[...e].length-1):/^\\+.+/.test(e)?e.replace(/^\\+/,""):e})).join("")}},89:(e,t,r)=>{r.d(t,{v:()=>a});const a=(e,t,r=!1)=>{const o=e=>{const t=Object.prototype.toString.call(e).slice(8,-1).toLowerCase();if("number"===t){if(Number.isNaN(e))return"NaN";if(!Number.isFinite(e))return"Infinity"}return t},s=e=>!!e&&"object"===o(e),n=e=>!!e&&Array.isArray(e);if(!s(e)||!s(t))throw new SyntaxError("引数target, source は、型 'object' である必要があります。");if("boolean"!==o(r))throw TypeError,new SyntaxError("引数concat は、型 'boolean' である必要があります。");const i={...e};Object.entries(t).map((t=>{const[o,c]=t,[m,l]=[o.toString(),e[o]];return r&&n(l)&&n(c)?i[m]=l.concat(...c):s(l)&&s(c)&&e.hasOwnProperty(m)?i[m]=a(l,c,r):Object.assign(i,{[o]:c})}));return{...i}}}},t={};function r(a){var o=t[a];if(void 0!==o)return o.exports;var s=t[a]={exports:{}};return e[a](s,s.exports,r),s.exports}r.d=(e,t)=>{for(var a in t)r.o(t,a)&&!r.o(e,a)&&Object.defineProperty(e,a,{enumerable:!0,get:t[a]})},r.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),(()=>{r(541);var e=r(89);window.MD=window.MD||{},window.MD.msecdeck=window.MD.msecdeck||{},window.MD.msecdeckObs=window.MD.msecdeckObs||{};const t=(0,e.v)({formatToken:"YYYY/MM/DD HH:mm:ss.SSS",formatTokenShort:"HH:mm.ss.SSS",options:{}},window.MD.msecdeck);window.MD.msecdeckObs.callback=e=>e.forEach((e=>{const{target:r,addedNodes:a}=e;if(!r)return!1;const o=[...r.classList||[]];if(!(([...e])=>e.map((e=>o.includes(e))))(["js-chirp-container","js-replies-to","js-replies-before","js-tweet-detail","js-message-detail"]).includes(!0))return!1;const s=[...a].map((e=>e)).filter((e=>[...e.classList||[]].includes("js-stream-item"))).map((e=>{const t=e.querySelector(".tweet-timestamp")||e.querySelector(".tweet-detail>.js-card-container+div.txt-mute>a:first-child");return{stream:e,timestamp:t,timestampChildren:t&&t.children[0]}})).filter((({timestamp:e})=>!!e)),n=e=>new Date(Math.floor(e/4194304)+1288834974657),i=e=>e<1e14;(([...e])=>{e.map((({stream:e,timestamp:r,timestampChildren:a})=>{r.classList.remove("js-timestamp");const o={a:e=>{const{ts:r,child:a}=e,o=Number(a.href.split("/")[5]),s=(i(o)?new Date(r.dataset.time):n(o)).format(t.formatTokenShort||"HH:mm.ss.SSS",t.options);a.textContent=s},span:e=>{const{ts:r,child:a}=e,o=Number(r.dataset.time),s=new Date(o).format(t.formatTokenShort||"HH:mm.ss.SSS",t.options);a.textContent=s},details:e=>{const{ts:r}=e,a=Number(r.href.split("/")[5]),o=(i(a)?new Date((r.textContent||"").replace(/(am|pm)\s·/," $1")):n(a)).format(t.formatToken||"YYYY/MM/DD HH:mm.ss.SSS",t.options);r.textContent=o}};var s;(o[(s=a,s&&s.tagName.toLowerCase())]||o.details)({stream:e,ts:r,child:a})}))})(s)})),window.MD.msecdeckObs.obs=new MutationObserver(window.MD.msecdeckObs.callback),window.MD.msecdeckObs.target=document.body,window.MD.msecdeckObs.init={childList:!0,subtree:!0},window.MD.msecdeckObs.obs.observe(window.MD.msecdeckObs.target,window.MD.msecdeckObs.init),(new Date).format("",{})})()})();


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
