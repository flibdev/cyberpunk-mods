
// Sets the quantity picker default to max rather than 1
@wrapMethod(ItemQuantityPickerController)
private final func SetData() -> Void {
  wrappedMethod();

  this.m_choosenQuantity = this.m_maxValue;
  this.m_sliderController.ChangeValue(Cast<Float>(this.m_maxValue));
}
