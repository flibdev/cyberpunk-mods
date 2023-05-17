
// Sets the quantity picker default based on settings
@wrapMethod(ItemQuantityPickerController)
private final func SetData() -> Void {
  wrappedMethod();

  // Fetch settings via the owning player
  let playerPuppet = this.GetPlayerControlledObject() as PlayerPuppet;
  let qtyDefault = flibSettings.Get(playerPuppet.GetGame()).QuantityPickerDefault;

  switch qtyDefault {
    case flibQuantityDefault.Min:
      this.m_choosenQuantity = 1;
      break;
    case flibQuantityDefault.Mid:
      this.m_choosenQuantity = this.m_maxValue / 2;
      break;
    case flibQuantityDefault.Max:
      this.m_choosenQuantity = this.m_maxValue;
      break;
  }

  this.m_sliderController.ChangeValue(Cast<Float>(this.m_choosenQuantity));
}
