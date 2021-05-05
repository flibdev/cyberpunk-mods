
public abstract class BaseClass {
  public func Foo() -> Void { Log("Base!"); }
}

public final class DerivedClass extends BaseClass {
  public func Foo() -> Void { Log("Derived!");  }
}

public class BeyondFinalClass extends DerivedClass {
  public func Foo() -> Void { Log("BeyondFinal!");  }
}

public static exec func TestInheritance(gi: GameInstance) {
  //let b: ref<BaseClass> = new BaseClass();
  let f: ref<BaseClass> = new BeyondFinalClass();

  //b.Foo();
  f.Foo();
}
