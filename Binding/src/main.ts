import * as marindeck from './marindeck'
// import * as binding from './binding'
import { MarinDeckInputs, MarinDeckInputsInterface } from './inputs'
import * as marindeckObject from "../MarinDeckObject/src"

declare global {
    interface Window {
        MarinDeckInputs: MarinDeckInputsInterface
    }
  }
  

marindeck
window.MarinDeckInputs = new MarinDeckInputs()
marindeckObject.configure()

// binding.openSettings()
// marindeck.postTweet("hello")