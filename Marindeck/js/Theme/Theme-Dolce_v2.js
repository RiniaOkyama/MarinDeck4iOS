(()=>{
/* テーマの設定ここから */
const theme = {
  prefix: 'dolce',
  name: 'Dolce',
  version: '2.0',
  author: 'L1n4r1A&RabiLuv',
  featuring: 'MDTG+taiy',
};
/* CSSを記入 */
const css = `:root{--choco:#714116;--vanilla:#ede7d4;--vanilla-light:#f6f4e1;--berry:#e06766;--berry-light:#e195a5;--whipcream:#ffecf1;--honey:#ffa500;--soda:#95a5e1;--melon:#95e1a5}:root{--prf-c:var(--choco);--prf-c-mute:var(--berry);--prf-c-link:var(--berry);--prf-c-border:var(--choco);--prf-bg:var(--vanilla-light);--prf-bg-header:var(--vanilla);--prf-c-focus:#0000;--prf-bg-focus:#0000}div.md-prf>.md-prf_contents>.username>.prf-follow-status{color:var(--whipcream)!important}body>.js-app-loading img[alt='Loading…']{content:url(https://cdn.discordapp.com/attachments/806512320779517952/807291592398471168/Dolce_loadingLogo256.png)!important;width:256px!important;height:256px!important;margin-left:calc(256px / -2 + 2px)!important;margin-top:calc(256px / -2 + 2px)!important}body>.js-app-loading{user-select:none!important;pointer-events:none!important;background-color:var(--vanilla)!important}body{margin:0!important}.compose{background-color:var(--vanilla)!important;color:var(--choco)!important}.compose-text-title{color:var(--choco)!important}.compose-media-bar-holder,.compose-message-account,.compose-message-recipient-input-container,.compose-text-container,.compose-text-container textarea,.js-quote-tweet-holder{background-color:var(--vanilla-light)!important;color:var(--choco)!important}.compose-message-recipient{background-color:var(--choco)!important;color:var(--vanilla-light)!important}.account-selector-grid-mode>.icon{color:var(--berry)!important}.compose-account{color:inherit!important;border-radius:10px!important;padding:4px!important;margin:-4px 4px 12px!important}.is-minigrid .compose-account{margin:-4px 1px 5px 0!important}.is-list .compose-account{margin:0 8px 2px!important}.compose-account-selected{background-color:var(--berry)!important;color:#fff!important}.compose-account-img{background-color:#0000!important}.compose-account:focus .compose-account-img{box-shadow:none!important}.compose-account.is-selected,.compose-account:active,.compose-account:focus{background-color:var(--choco)!important;color:var(--vanilla-light)!important}.compose-send-button-success{color:var(--berry)!important}.replyto-caret{display:none!important}.compose-text-container>.txt-right{position:absolute!important;right:10px!important;bottom:10px!important;margin:0!important;pointer-events:none!important}.js-character-count,.js-character-count.is-hidden,html.dark .js-character-count,html.dark .js-character-count.is-hidden{display:inline!important;margin-right:0!important}.js-progress-svg{margin-left:6px!important}.js-character-count,html.dark .js-character-count{padding:2px 4px!important;background:var(--choco)!important;color:#fff!important;border-radius:3px!important;font-family:monospace,monospace!important}.js-character-count.color-twitter-red,html.dark .js-character-count.color-twitter-red{background:var(--berry)!important}.js-progress-svg circle.stroke-twitter-light-gray{stroke:var(--vanilla)!important}.js-progress-svg circle.stroke-twitter-blue{stroke:var(--choco)!important}.js-progress-svg circle.stroke-twitter-yellow{stroke:var(--berry-light)!important}.js-progress-svg circle.stroke-twitter-red{stroke:var(--berry)!important}#calbody,#calweeks,.popover{background-color:var(--vanilla-light)!important}#caldays span,.cal,.cal a:not(.caldisabled),.cal input{color:var(--choco)!important}#caltoday{background-color:var(--berry)!important;color:var(--vanilla-light)!important}#calcurrent{background-color:var(--choco)!important;color:var(--vanilla-light)!important}.inline-reply{background-color:var(--choco)!important;color:var(--vanilla-light)!important;border-radius:0 0 10px 10px!important}.reply-triangle{border-bottom-color:var(--choco)!important}.inline-reply .compose-account.is-selected,.inline-reply .compose-account:active,.inline-reply .compose-account:focus{background-color:var(--vanilla-light)!important}.inline-reply .icon{color:var(--vanilla-light)!important}.inline-reply .compose-account{margin:-4px!important}.inline-reply .compose-text{height:100px!important}html :not(.md-customDM)>.stream-item{margin:5px 10px!important}.gap-chirp{color:var(--berry)!important;top:0!important}.gap-chirp>.item-box{padding:10px!important}.gap-chirp::after,.gap-chirp::before{content:none!important}.activity-header+.tweet.txt-mute>.js-show-this-thread,.activity-header+.tweet.txt-mute>.tweet-body .other-replies,.activity-header+.tweet.txt-mute>.tweet-header{display:none!important}.social-proof-for-tweet-title{margin:5px 10px!important;padding:10px!important;background-color:var(--choco)!important;color:var(--vanilla-light)!important;border:0!important;border-radius:10px!important}.tweet-drag-handle{display:none!important}.js-infinitespinner{height:auto!important;text-align:center!important;margin:5px 10px 10px!important;padding:10px!important;background:0 0!important;background-color:var(--vanilla-light)!important;border-radius:10px!important}.js-infinitespinner::before{content:'Loading...'!important;color:var(--berry)!important;font-size:15px!important}.column-loading-placeholder .spinner-small{display:none!important}.list-placeholder,.list-placeholder .l-cell{display:block!important;margin:0!important;padding:0!important}.list-placeholder p{margin:5px 10px!important;padding:10px!important;text-shadow:none!important;color:var(--berry)!important;background-color:var(--vanilla-light)!important;border-radius:10px!important;font-size:15px!important}.prf-header{border-radius:0!important}.prf-header-inner-overlay{width:100%!important;height:100%!important;background:rgba(0 0 0 / .25)!important;backdrop-filter:blur(2px)!important}.prf-img>.avatar-border--2{border:0!important}.prf .lst-profile i{color:var(--berry)!important}.prf .lst-profile span{color:var(--choco)!important}.prf-stats a strong{color:var(--choco)!important}.follow-btn .Icon,.follow-btn .icon,button.btn-options-tray:focus,button.btn-options-tray:hover,button:not(.text-hidden),input[type=button].btn-options-tray:focus,input[type=button].btn-options-tray:hover{color:var(--berry)!important}button:not(.Button--link):not(.Notification-closeButton){background-color:var(--vanilla-light)!important;border:solid 1px var(--choco)!important}button:not(.Button--link):not(.Notification-closeButton):active,button:not(.Button--link):not(.Notification-closeButton):focus{box-shadow:none!important;background-color:rgba(224 103 102 / .2)!important}.dropdown-menu,.lst-modal{background-color:var(--vanilla-light)!important}.lst-modal{border-radius:6px!important}.caret-inner{border-bottom-color:var(--vanilla-light)!important}.dropdown-menu a{color:var(--choco)!important}.dropdown-menu .is-selected,.lst .s-selected{background-color:var(--choco)!important;color:var(--vanilla-light)!important}.dropdown-menu .is-selected a{color:inherit!important}.list-item-last{border-bottom-left-radius:0!important;border-bottom-right-radius:0!important}.dropdown-menu .is-selected,.list-account:hover:active,.list-account:hover:focus,.list-account:hover:hover,.lst .s-selected,.lst-group .selected,.lst-group .selected a:hover{background-color:var(--choco)!important;color:var(--vanilla-light)!important}.dropdown-menu .is-selected a,.list-account,.list-account .username,.lst-group .selected a{color:inherit!important;text-decoration:none!important}.list-item-last{border-bottom-left-radius:0!important;border-bottom-right-radius:0!important}.lst-launcher .column-type-icon~span,.lst-launcher .is-disabled .column-type-icon~span{color:var(--choco)!important}.lst-launcher .column-type-icon,.lst-launcher .is-disabled .column-type-icon{color:var(--berry)!important}.js-app .js-column .column-header .column-title-edit-box,.js-app .js-column .js-add-to-customtimeline input,.js-app .js-column-options-container .with-column-divider-bottom{color:var(--choco)!important;background-color:var(--vanilla-light)!important}.focus,input:focus,select:focus,textarea:focus{border-color:var(--berry)!important}.column-header-temp .focus,.column-header-temp input:focus,.column-header-temp select:focus,.column-header-temp textarea:focus,.column-header-title .focus,.column-header-title input:focus,.column-header-title select:focus,.column-header-title textarea:focus{border-color:var(--honey)!important}.js-modals-container .prf .prf-meta{background-color:var(--vanilla-light)!important}.prf,.s-profile{background-color:var(--vanilla-light)!important}.overlay,.ovl{backdrop-filter:blur(4px)!important}.js-chirp-container{background-color:var(--vanilla)!important}.column-header-title{background-color:var(--vanilla)!important}.column-header .column-header-temp{color:var(--whipcream)!important;background-color:var(--berry)!important}.icon-protected{color:var(--choco)!important}.column-number{color:var(--choco)!important;top:5px!important;left:5px!important}.column-drag-handle{display:none!important}div.mdl,div.mdl-column-med{background-color:var(--vanilla)!important;color:var(--choco)!important}.mdl-accent{background-color:var(--vanilla-light)!important}.mdl-header-divider{border-bottom:0!important}.column-header-temp,.column-header-title{background-color:var(--berry)!important}.column-header-title{height:49px!important}.column-title{color:var(--whipcream)!important}.column-header .column-type-icon{color:var(--choco)!important}.is-new .column-type-icon{color:var(--honey)!important}.js-app .js-column .column-message{background-color:var(--vanilla)!important}.column-header{z-index:100!important}.is-options-open .column-options{padding-top:10px!important;margin-top:-10px!important}.accordion-panel{padding-top:8px!important}.location-form .Icon--close,.location-form .icon-close,.location-form .icon-translator{top:calc(25px + 8px)!important}.accordion-header,.column-options,.column-options .button-tray{background-color:var(--vanilla-light)!important}.facet-type.is-active{background-color:var(--choco)!important}.accordion .is-active .accordion-header,.accordion .is-active .accordion-header:hover,.facet-subtitle{color:var(--choco)!important}.accordion .is-active .control-label:not(input):not(select):not(option),.accordion .is-active .controls:not(input):not(select):not(option),.accordion .is-active .txt-mute:not(input):not(select):not(option),.txt-mute-text-only{color:var(--vanilla-light)!important}.accordion .is-active input,.accordion .is-active option,.accordion .is-active select{color:#14171a!important}.mdl .column-temp:not(.is-options-open) .column-options{display:none!important}[data-testid=filterMessage]{display:none!important}.js-action-filter-error,.js-notification-filter-info,.js-quality-filter-info{display:none!important}.more-tweets-glow{--more-glow:var(--honey);background:radial-gradient(ellipse farthest-corner at 50% 100%,var(--more-glow) 0,var(--more-glow) 25%,#fff0 75%)!important}.column-nav-updates{color:var(--honey)!important}.numbered-badge{color:var(--whipcream)!important;background-color:var(--honey)!important;border-color:var(--whipcream)!important}.tweet-body.l-cell>.tweet-text:not(.js-tweet-text){color:var(--berry-light)!important;font-size:.85714rem!important}.tweet-body.l-cell>.txt-italic.txt-mute{color:var(--choco)!important;font-style:normal!important}.js-app .js-column .js-tweet-detail{background-color:var(--vanilla-light)!important}.js-app .column-detail .scroll-conversation{background-color:var(--vanilla-light)!important}.tweet-detail-action[rel=reply]{color:var(--soda)!important}.tweet-detail-action[rel=retweet]{color:var(--melon)!important}.tweet-detail-action[rel=favorite]{color:var(--berry)!important}.tweet-detail-action[rel=actionsMenu]{color:var(--choco)!important}.column-header-title,.column-title .attribution,.column-title-back,.column-title-container,.column-title-container .username.txt-mute{color:var(--whipcream)!important}.username.txt-mute{color:var(--berry-light)!important}:root{--color1:var(--vanilla-light);--fColor1:var(--berry);--fColorA1:var(--choco);--color2:var(--vanilla-light);--fColor2:var(--choco);--fColorA2:var(--berry)}html .md-customDM>article{min-height:unset!important}html .md-customDM>article[md-onajiuser=top]{margin:-1px 0 6px!important}html .md-customDM>article[md-onajiuser=top]>div{padding:8px 10px 0!important}html .md-customDM>article[md-onajiuser=bottom]{margin:-1px 0 0!important}html .md-customDM>article[md-onajiuser=bottom]>div{padding:0 10px!important}html .md-customDM>article[md-onajiuser='bottom last']{margin:6px 0 -1px!important}html .md-customDM>article[md-onajiuser='bottom last']>div{padding:0 10px 8px!important}html .js-message-detail.md-customDM>article{background-color:#0000!important}html .md-customDM>article .tweet>div.tweet-body>.tweet-text{background-color:var(--color1)!important;color:var(--fColor1)!important}html .md-customDM>article.md-myMsg .tweet>div.tweet-body>.tweet-text{background-color:var(--color2)!important;color:var(--fColor2)!important}html .md-customDM>article .tweet>div.tweet-body>.quoted-tweet{border-color:var(--color1)!important}html .md-customDM>article.md-myMsg .tweet>div.tweet-body>.quoted-tweet{border-color:var(--color2)!important}html .md-customDM>article .tweet>div.tweet-body>.tweet-text>a{text-decoration:underline;color:var(--fColorA1)!important}html .md-customDM>article.md-myMsg .tweet>div.tweet-body>.tweet-text>a{text-decoration:underline;color:var(--fColorA2)!important}.rpl textarea{color:var(--choco)!important;background-color:var(--vanilla-light)!important}.add-participant{margin:5px 10px!important;padding:10px!important;background-color:var(--vanilla-light)!important;color:var(--choco)!important;border:0!important;border-radius:10px!important}.add-participant input{background-color:#0000!important}::selection{background:var(--honey)!important;color:inherit!important;text-shadow:none!important}.account-link{color:var(--berry)!important}.compose .quoted-tweet .tweet-avatar{display:none!important}.column-background-fill{background-color:#0000!important}.js-show-this-thread,.js-show-this-thread>*{color:var(--choco)!important}.thread.cursor-top-thread,.thread.dot-thread,.thread.show-more-thread{left:calc(27px + 10px)!important}.column .column-content,html.dark .column .column-content{background-color:#0000!important}.old-composer-footer{background-color:#0000!important}.compose-remember-state{color:inherit!important}.scheduled-tweet{border-color:var(--berry)!important;border-radius:10px!important}.compose-message-recipient-input-container.is-focused{box-shadow:none!important}.accounts-drawer{color:var(--choco)!important}.accounts-drawer .accordion,.accounts-drawer .accordion .is-active,.accounts-drawer .column-close-link,.accounts-drawer .column-title,.accounts-drawer .icon,.accounts-drawer a,.join-team{color:inherit!important}.account-profile-header,.account-settings-row,.join-team{background-color:#0000!important}.app-columns-container,.app-content{background-color:var(--vanilla)!important}.column-panel{background-color:var(--vanilla)!important}body{background-color:var(--vanilla)!important}.column-header{background-color:var(--berry)!important;border-radius:0 0 10px 10px;color:var(--whipcream)!important}.stream-item{background-color:var(--vanilla-light)!important;border-radius:10px;color:var(--choco)!important}.media-grid-container,.media-item{border-radius:10px!important}.quoted-tweet{border-color:var(--berry)!important;border-radius:10px}.tweet-action[rel=favorite]{color:var(--berry)!important}.tweet-action[rel=actionsMenu]{color:var(--choco)!important}a{color:var(--berry)!important}.column-header-link{color:var(--choco)!important}html{color:var(--choco)!important}.tweet-action[rel=reply]{color:var(--soda)!important}.tweet-action[rel=retweet]{color:var(--melon)!important}`;
/* テーマの設定ここまで */
const h=document.documentElement;h.classList.add(`md-theme-${theme.prefix}`);h.id=theme.prefix;h.dataset.mdTheme=`${theme.name}/${theme.version}`;const s=document.createElement('style');s.insertAdjacentHTML('beforeend',css);h.insertAdjacentElement('beforeend',s)
})();