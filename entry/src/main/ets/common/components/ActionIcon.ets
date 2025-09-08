@Component
export struct ActionIcon {
  @Prop icon: Resource

  build() {
    Image(this.icon)
      .width(34)
      .height(34)
      .borderRadius(24)
      .padding(6)
      .backgroundColor('#343a40')
  }
}