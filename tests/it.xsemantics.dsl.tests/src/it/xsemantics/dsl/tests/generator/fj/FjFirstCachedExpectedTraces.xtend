package it.xsemantics.dsl.tests.generator.fj

import it.xsemantics.dsl.tests.generator.fj.common.FjExpectedTraces

class FjFirstCachedExpectedTraces extends FjExpectedTraces {

	override methodCallCheckOk()
'''CheckSelection: [] |- new B().m(new B(), new B(), 10)
 CheckNew: [] |- new B()
  Fields: [] ||- class B extends A { int m(B b, A a, int ... >> []
   superclasses(class B extends A { int m(B b, A a, int ...) = [class A { }]
  SubtypeSequence: [] |- new B() : [] << []
 SubtypeSequence: [] |- new B().m(new B(), new B(), 10) : [new B(), new B(), 10] << [B b, A a, int i]
  TNew: [] |- new B() : B
  TTypedElement: [] ||- B b : B
  ClassSubtyping: [] |- B <: B
   Subclassing: [] |- class B extends A { int m(B b, A a, int ... <| class B extends A { int m(B b, A a, int ...
  TNew: [] |- new B() : B
  TTypedElement: [] ||- A a : A
  ClassSubtyping: [] |- B <: A
   Subclassing: [] |- class B extends A { int m(B b, A a, int ... <| class A { }
    Subclassing: [] |- class A { } <| class A { }
  TIntConstant: [] |- 10 : int
  TTypedElement: [] ||- int i : int
  BasicSubtyping: [] |- int <: int
 CheckNew: [] |- new B()
  cached:
   Fields: [] ||- class B extends A { int m(B b, A a, int ... >> []
  SubtypeSequence: [] |- new B() : [] << []
 CheckNew: [] |- new B()
  cached:
   Fields: [] ||- class B extends A { int m(B b, A a, int ... >> []
  SubtypeSequence: [] |- new B() : [] << []
 CheckConstant: [] |- 10'''
}