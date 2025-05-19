import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

// Connects to data-controller="bridge--button"
export default class extends BridgeComponent {
  static component = "button"

  connect() {
    super.connect()
   
    const title = this.bridgeElement.bridgeAttribute("title")
    const imageName = this.bridgeElement.bridgeAttribute("ios-image-name")
    const iconName = this.bridgeElement.bridgeAttribute("android-icon-name")
    this.send("connect", {title, imageName, iconName}, () => {
      this.bridgeElement.click()
    })
  }

  disconnect() {
    super.disconnect() 
    this.send("disconnect")
  }
}
