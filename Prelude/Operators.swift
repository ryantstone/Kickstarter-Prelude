precedencegroup LeftApplyPrecedence {
  associativity: left
  higherThan: AssignmentPrecedence
  lowerThan: TernaryPrecedence
}

precedencegroup FunctionCompositionPrecedence {
  associativity: right
  higherThan: LeftApplyPrecedence
}

precedencegroup LensCompositionPrecedence {
  associativity: right
  higherThan: LensSetPrecedence
}

precedencegroup LensSetPrecedence {
  associativity: left
  higherThan: FunctionCompositionPrecedence
}

/// Pipe forward function application.
infix operator |> : LeftApplyPrecedence

/// Infix, flipped version of fmap (for arrays), i.e. `xs ||> f := f <^> xs`
infix operator ||> : LeftApplyPrecedence

/// Infix, flipped version of fmap (for optionals), i.e. `x ?|> f := f <^> x`
infix operator ?|> : LeftApplyPrecedence

/// Composition
infix operator • : FunctionCompositionPrecedence

/// Lens composition
infix operator .. : LensCompositionPrecedence

/// Semigroup binary operation
infix operator <> : FunctionCompositionPrecedence

/// Semigroup operation partially applied on right
prefix operator <>

/// Semigroup operation partially applied on left
postfix operator <>

/// Lens view
infix operator ^* : LeftApplyPrecedence

/// Lens set
infix operator .~ : LensSetPrecedence

/// Lens over
infix operator %~ : LensSetPrecedence

/// Lens over with both part and whole.
infix operator %~~ : LensSetPrecedence

/// Lens semigroup
infix operator <>~ : LensSetPrecedence

/// Kleisli lens composition
infix operator >•>

/// Compose forward operator
infix operator >>> : FunctionCompositionPrecedence

/// Compose backward operator
infix operator <<< : FunctionCompositionPrecedence

/// Cons of an element with a non-empty collection.
infix operator +|: AdditionPrecedence

//infix operator >>- : FunctionCompositionPrecedence
//
//public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
//  return a.flatMap(f)
//}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  return { b in
    { a in
      f(a)(b)
    }
  }
}
infix operator >-> : FunctionCompositionPrecedence
/**
  compose two functions that produce optional values, from left to right
  - If the result of the first function is `.none`, the second function will
    not be inoked and this will return `.none`
  - If the result of the first function is `.some`, the value is unwrapped and
    passed to the second function which may return `.none`
  - parameter f: A transformation function from type `T` to type `Optional<U>`
  - parameter g: A transformation function from type `U` to type `Optional<V>`
  - returns: A function from type `T` to type `Optional<V>`
*/
public func >-> <T, U, V>(f: @escaping (T) -> U?, g: @escaping (U) -> V?) -> (T) -> V? {
  return { x in f(x) >>- g }
}

infix operator >>- : FunctionCompositionPrecedence
/**
  flatMap a function over an optional value (left associative)
  - If the value is `.none`, the function will not be evaluated and this will
    return `.none`
  - If the value is `.some`, the function will be applied to the unwrapped
    value
  - parameter f: A transformation function from type `T` to type `Optional<U>`
  - parameter a: A value of type `Optional<T>`
  - returns: A value of type `Optional<U>`
*/
public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
  return a.flatMap(f)
}
