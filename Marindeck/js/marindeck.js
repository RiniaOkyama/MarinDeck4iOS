var __defProp = Object.defineProperty;
var __defProps = Object.defineProperties;
var __getOwnPropDescs = Object.getOwnPropertyDescriptors;
var __getOwnPropSymbols = Object.getOwnPropertySymbols;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __propIsEnum = Object.prototype.propertyIsEnumerable;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __spreadValues = (a, b) => {
  for (var prop in b || (b = {}))
    if (__hasOwnProp.call(b, prop))
      __defNormalProp(a, prop, b[prop]);
  if (__getOwnPropSymbols)
    for (var prop of __getOwnPropSymbols(b)) {
      if (__propIsEnum.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    }
  return a;
};
var __spreadProps = (a, b) => __defProps(a, __getOwnPropDescs(b));
document.body.style.backgroundColor = "#15202b";
document.documentElement.style.webkitUserSelect = "none";
document.documentElement.style.webkitTouchCallout = "none";
const viewport = document.querySelector("meta[name=viewport]");
if (viewport) {
  viewport.content += ",maximum-scale=1";
}
let mR = moduleRaid();
mR && mR.findFunction("jQuery") && mR.findFunction("jquery:")[0];
const sleep = (msec) => new Promise((resolve) => setTimeout(resolve, msec));
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
  new MutationObserver((records) => {
    return [...records || []].forEach((record) => {
      const target = record.target;
      if (target instanceof HTMLElement) {
        const isOpenModal = target.id === "open-modal";
        if (isOpenModal) {
          const mediatable = target.querySelector(".js-mediatable");
          const dismiss = target.querySelector(".js-dismiss");
          const isVideo = target.getElementsByTagName("video").length > 0;
          console.log(isVideo);
          if (!isVideo) {
            if (mediatable && dismiss)
              dismiss.click();
          }
        }
        const video = target.querySelector("video");
        if (video !== null) {
          const isGif = video.classList.contains("js-media-gif");
          if (isGif) {
            video.setAttribute("controls", "");
            video.setAttribute("playsinline", "");
            video.setAttribute("webkit-playsinline", "");
            const cl = video.classList.value;
            video.classList.value = "-";
            window.setTimeout(function() {
              video.classList.value = cl;
            }, 1);
          }
        }
      }
    });
  }).observe(document.body, { childList: true, subtree: true });
})();
function isTweetButtonHidden(bool) {
  webkit.messageHandlers.isTweetButtonHidden.postMessage(bool);
}
function loginStyled() {
  document.querySelector(".startflow-background").hidden = true;
  document.querySelector(".startflow-background").style.backgroundColor = "#252525";
  document.querySelector(".app-info-panel").style.margin = "92px auto";
  document.querySelector(".login-container").style.minHeight = "0px";
  document.querySelector(".app-info-title").innerText = "MarinDeck\u3078\u3088\u3046\u3053\u305D";
  document.querySelector(".app-info-title").style.fontSize = "22px";
  document.querySelector(".app-info-text p").innerText = "";
  document.querySelectorAll(".js-startflow-chrome")[1].hidden = true;
  document.querySelector(".js-login-form").style.backgroundColor = "rgb(30,41,55)";
  document.querySelector(".js-login-form").border = null;
  document.querySelector("#login-form-title").innerText = "Twitter\u30A2\u30AB\u30A6\u30F3\u30C8\u3067\u30ED\u30B0\u30A4\u30F3";
  document.querySelector("#login-form-title").style.fontSize = "16px";
  document.querySelector(".js-login-form .Button").innerText = "\u30ED\u30B0\u30A4\u30F3";
  document.querySelector("#login-form-title").style.color = "white";
  document.querySelector(".js-login-form").style.backgroundColor = "transparent";
  document.querySelector(".js-login-form").style.borderStyle = "none";
  document.querySelector("#login-form-title").style.borderStyle = "none";
  document.querySelector(".divider-bar").style.display = "none";
  document.querySelector(".js-signin-ui").style.margin = "10% auto";
  document.querySelector(".js-signin-ui").style.width = "98%";
  document.querySelector(".js-login-form .Button").style.padding = "13px";
  document.querySelector(".sprite-logo").remove();
  document.querySelector(".app-info-text").style.textAlign = "center";
  document.querySelector(".app-info-text").style.width = "100%";
  document.querySelectorAll(".app-signin-wrap")[1].style.width = null;
  document.querySelector(".js-signin-ui .Button").style.borderRadius = "6px";
  document.querySelector(".js-signin-ui .Button").style.outline = "none";
  document.querySelectorAll(".app-signin-wrap")[1].style.width = "100%";
  document.querySelector(".startflow-link").removeAttribute("target");
  isTweetButtonHidden(true);
}
function swiftLog(...msg) {
  console.log("JS Log:", msg);
  webkit.messageHandlers.jsCallbackHandler.postMessage(msg);
}
function positionElement(x, y) {
  webkit.messageHandlers.jsCallbackHandler.postMessage("CALLED position element");
  const element = document.elementFromPoint(x, y);
  console.log(element);
  webkit.messageHandlers.jsCallbackHandler.postMessage(String(element.style.backgroundImage));
  if (!element.classList.contains("js-media-image-link") && !element.classList.contains("media-img")) {
    console.log(element.classList);
    return;
  }
  let imgUrls = [];
  let selectIndex = 0;
  let positions = [];
  element.parentElement.parentElement.querySelectorAll(".js-media-image-link").forEach(function(item, index) {
    if (item === element) {
      selectIndex = index;
    }
    const img = item.style.backgroundImage;
    if (img === "") {
      imgUrls.push(item.querySelector("img").src);
    } else {
      imgUrls.push(img);
    }
    const rect = item.getBoundingClientRect();
    positions.push([rect.left, rect.top, rect.width, rect.height]);
  });
  webkit.messageHandlers.imageViewPos.postMessage(positions);
  return [selectIndex, imgUrls];
}
(async () => {
  let endedlist = [];
  new MutationObserver((records) => {
    document.querySelectorAll(".js-media-image-link").forEach(function(image) {
      if (endedlist.indexOf(image) === -1) {
        endedlist.push(image);
        if (image.parentElement.classList.contains("is-video")) {
          if (image.href.includes("youtube.com")) {
            image.addEventListener("click", function(clickedItem) {
              const url = clickedItem.target.href;
              webkit.messageHandlers.openYoutube.postMessage(url);
            });
          }
        } else {
          image.addEventListener("click", function(clickedItem) {
            swiftLog("image onClick");
            const res = positionElement(clickedItem.x, clickedItem.y);
            webkit.messageHandlers.imagePreviewer.postMessage(res);
          });
        }
      }
    });
  }).observe(document.body, { childList: true, subtree: true });
})();
const Version = "0";
const genUUID = () => Array.from("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", (char) => char === "x" ? Math.floor(Math.random() * 16).toString(16) : char === "y" ? (Math.floor(Math.random() * 4) + 8).toString(16) : char).join("");
const Native = {
  _post: function({ object, string }) {
    try {
      if (!window.webkit)
        throw new Error();
      window.webkit.messageHandlers.general.postMessage(object);
    } catch {
    }
    console.log("mdnative:", string);
  },
  post: function({ type, body }) {
    const uuid = genUUID();
    this._post({
      object: { type, body, uuid, method: "post" },
      string: JSON.stringify({ type, body, uuid, method: "post" })
    });
  },
  get: function({ type, body }) {
    return new Promise((resolve, _) => {
      const uuid = genUUID();
      const eventType = "mdnativesend";
      const eventListener = (event) => {
        const { detail: { value, uuid: U } } = event;
        if (U === uuid) {
          window.removeEventListener(eventType, eventListener);
          resolve(value);
        }
      };
      window.addEventListener(eventType, eventListener);
      this._post({
        object: { type, body, uuid, method: "get" },
        string: JSON.stringify({ type, body, uuid, method: "get" })
      });
    });
  },
  send: function({ uuid, value }) {
    window.dispatchEvent(new CustomEvent("mdnativesend", {
      detail: { uuid, value, method: "send" }
    }));
  }
};
const configure = () => {
  window.MD = __spreadProps(__spreadValues({}, window.MD || {}), {
    Version,
    Native
  });
};
configure();
