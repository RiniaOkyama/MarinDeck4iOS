document.body.style.backgroundColor = "#15202b";
// select 禁止
document.documentElement.style.webkitUserSelect='none';
// menu 禁止
document.documentElement.style.webkitTouchCallout='none';

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
    try{
        webkit.messageHandlers.jsCallbackHandler.postMessage("didLoad");
        webkit.messageHandlers.viewDidLoad.postMessage(true);
    }catch(e){swiftLog("ERROR! viewDidLoad Faild " + String(e));}
    try{
        loginStyled();
        swiftLog("login style changed");
    }catch(e){swiftLog("login load error" + String(e));}
    
    // 画像のモーダルを抹殺
    new MutationObserver((records) => {
      return [...records || []].forEach((record) => {
        const target = record.target
        if (target instanceof HTMLElement) {
          const isOpenModal = target.id === 'open-modal'
          if (isOpenModal) {
            const mediatable = target.querySelector('.js-mediatable')
            const dismiss = target.querySelector('.js-dismiss')
            if (mediatable && dismiss) dismiss.click()
          }
        }
      })
    }).observe(document.body, {childList: true, subtree: true})

})();


// カラムのスクロール。 Menu開くときにカラムと一緒に動かなくするため。
const columnScroll = {
  style: null,
  init: () => {
    if (!columnScroll.style) {
      columnScroll.style = document.createElement('style')
      document.head.insertAdjacentElement('beforeend', columnScroll.style)
    }
    columnScroll.style.textContent = ''
  },
  on: () => {
    columnScroll.init()
    columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:auto!important}')
  },
  off: () => {
    columnScroll.init()
    columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:hidden!important}')
  }
}

document.addEventListener('touchstart', (e) => {
  if (e.touches[0].clientX <= 8) {
    columnScroll.off()
  } else {
    columnScroll.on()
  }
}, { passive: true })


function isTweetButtonHidden(bool) {
    webkit.messageHandlers.isTweetButtonHidden.postMessage(bool);
}


function loginStyled(){
    document.querySelector("body > div.js-app-loading.login-container > div.startflow-background.pin-all.anim.anim-slower.anim-fade-in").hidden = true;
    document.querySelector("body > div.js-app-loading.login-container > div.startflow-background.pin-all.anim.anim-slower.anim-fade-in").style.backgroundColor = "#252525";
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.app-info.txt-size-variable--18.margin-txxl > div > div > h2").innerText = "MarinDeckへようこそ";
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.app-info.txt-size-variable--18.margin-txxl > div > div > h2").style.fontSize = "25px"
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.app-info.txt-size-variable--18.margin-txxl > div > div > p").innerText = "廃人への第一歩、そしてその先へ";
    document.querySelector("body > div.js-app-loading.login-container > footer").hidden = true;
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section").style.backgroundColor = "rgb(30,41,55)";
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section").border = null;
    document.querySelector("#login-form-title").innerText = "Twitterアカウントでログイン"
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section > div.margin-a--16 > a").innerText = "ログイン";
    document.querySelector("#login-form-title").style.color = "white";
    
    // ログイン透明化
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section").style.backgroundColor = "transparent";
    // ログインボーダー
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section").style.borderStyle = "none";
    document.querySelector("#login-form-title").style.borderStyle = "none";
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section > div.divider-bar.margin-v--0.margin-h--16").style.display = "none";
    
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal").style.margin = "30% 0px 0px";
    // login btn
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-content.startflow.anim.anim-slow.anim-fade-in > div > div.js-signin-ui.app-signin-form.pin-top.pin-right.txt-weight-normal > section > div.margin-a--16 > a").style.padding = "13px";
    
    //tweetdeck icon
    document.querySelector("body > div.js-app-loading.login-container > div.js-startflow-chrome.app-masthead.anim.anim-slow.anim-delayed.anim-fade-in > div > h1").remove();
}

function style_init(){
    // FIXME
    document.querySelectorAll(".js-media").forEach(item => {
        item.style.height = "130px";
    });
    
}

///////////////////////////////////////

function addTweetImage(base64, type, name) {
    var bin = atob(base64.replace(/^.*,/, '')); // decode base64
    var buffer = new Uint8Array(bin.length); // to binary data
    for (var i = 0; i < bin.length; i++) {
        buffer[i] = bin.charCodeAt(i);
    }
    const imgFile = new File([buffer.buffer], name, {type: type});
    
    jq(document).trigger("uiFilesAdded",{files: [imgFile]});
}

function swiftLog(...msg){
  webkit.messageHandlers.jsCallbackHandler.postMessage(msg);
}

function openSettings(){
    webkit.messageHandlers.openSettings.postMessage(true);
}

function touchPointTweetLike(x, y) {
    document.elementFromPoint(x, y).closest(".tweet").getElementsByClassName("tweet-action")[2].click();
}

function positionElement(x,y){
    webkit.messageHandlers.jsCallbackHandler.postMessage("CALLED position element");
    const element = document.elementFromPoint(x, y);
    webkit.messageHandlers.jsCallbackHandler.postMessage(String(element.style.backgroundImage));

    let openImgNum = 0
    let imgUrls = []
    element.parentElement.parentElement.querySelectorAll(".js-media-image-link").forEach(function(item, index){
      imgUrls.push(item.style.backgroundImage);
      if (item == element){
          openImgNum = index;
          swiftLog("openImgNum", index);
      }
    })

    var rect = element.getBoundingClientRect();
    webkit.messageHandlers.imageViewPos.postMessage([rect.left, rect.top, rect.width, rect.height]);
    // webkit.messageHandlers.imagePreviewer.postMessage(imgUrls);
    return [openImgNum, imgUrls]
}

function triggerEvent(element, event) {
   if (document.createEvent) {
       // IE以外
       var evt = document.createEvent("HTMLEvents");
       evt.initEvent(event, true, true ); // event type, bubbling, cancelable
       return element.dispatchEvent(evt);
   } else {
       // IE
       var evt = document.createEventObject();
       return element.fireEvent("on"+event, evt);
   }
}

//var a = document.getElementByClassName("js-media-image-link")[0];
//triggerEvent(a, 'mouseover');
//document.querySelectorAll(".open-modal").forEach(aa => aa.style.display = "none")

webkit.messageHandlers.jsCallbackHandler.postMessage("Message from Javascript");




function SecretMode(){
    
    document.querySelector("#container > div > section:nth-child(1) > div > div:nth-child(1) > header > div > div.column-header-title.flex.flex-align--center.flex-wrap--wrap.flex-grow--2 > span.attribution.txt-mute.txt-sub-antialiased.txt-ellipsis.vertical-align--baseline").innerText = "@realgeorgehotz"
    
    document.querySelectorAll(".tweet-avatar").forEach(function(avatar){
        avatar.src = "https://pbs.twimg.com/media/Er2rCrkVoAIRze0?format=png&name=240x240"
    })
    document.querySelectorAll(".fullname").forEach(function(item){
        item.innerText = "Anonymous"
    })
    document.querySelectorAll(".username").forEach(function(item){
        item.innerText = "@secret"
    })
    document.querySelectorAll(".other-replies-link").forEach(function(item){
        item.innerText = "@olvrheldeep"
    })
}


//(async () => {
//    await sleep(5000);
//    SecretMode()
////    while(true){
////        await sleep(1000);
////        SecretMode()
////    }
//})();


(async () => {
    let endedlist = []
    while(true){
        await sleep(1000);
        
        document.querySelectorAll(".js-media-image-link").forEach(function(image){
          if (endedlist.indexOf(image) >= 0) {
              
          }
          else{
            endedlist.push(image);
//              webkit.messageHandlers.loadImage.postMessage(String(image.style.backgroundImage));
            image.addEventListener("click", function(clickedItem){
              const res = positionElement(clickedItem.x, clickedItem.y);
              webkit.messageHandlers.imagePreviewer.postMessage(res);
            });
          }
        });
    }
})();
