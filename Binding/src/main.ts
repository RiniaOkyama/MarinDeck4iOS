import * as marindeck from './marindeck'
//@ts-ignore TS6133: 'req' is declared but its value is never read.
import { MarinDeckBindings, MarinDeckBindingsInterface } from './binding'
import { MarinDeckInputs, MarinDeckInputsInterface } from './inputs'
import * as marindeckObject from "../MarinDeckObject/src"

declare global {
    interface Window {
        MarinDeckInputs: MarinDeckInputsInterface,
        Bindings: MarinDeckBindingsInterface
    }
  }
  

marindeck
window.MarinDeckInputs = new MarinDeckInputs()
window.Bindings = new MarinDeckBindings()
marindeckObject.configure()

// binding.openSettings()
// marindeck.postTweet("hello")