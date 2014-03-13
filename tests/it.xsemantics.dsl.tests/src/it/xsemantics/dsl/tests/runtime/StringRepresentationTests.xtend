package it.xsemantics.dsl.tests.runtime

import com.google.inject.Inject
import it.xsemantics.dsl.XsemanticsInjectorProvider
import it.xsemantics.dsl.tests.XsemanticsBaseTest
import it.xsemantics.dsl.tests.classes.CustomStringRepresentation
import it.xsemantics.runtime.RuleEnvironment
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import it.xsemantics.runtime.Result
import it.xsemantics.runtime.RuleFailedException
import it.xsemantics.runtime.Result2
import it.xsemantics.runtime.Result3
import it.xsemantics.dsl.xsemantics.XsemanticsFactory

@InjectWith(typeof(XsemanticsInjectorProvider))
@RunWith(typeof(XtextRunner))
class StringRepresentationTests extends XsemanticsBaseTest {
	
	@Inject extension CustomStringRepresentation
	
	@Test
	def testRule() {
		assertEqualsStrings("rule EClassEObject derives G |- EClass e...",
			testFiles.testSimpleRule.firstRule.string
		)
	}
	
	@Test
	def testSimpleJavaObject() {
		assertEqualsStrings("foo", "foo".string)
	}
	
	@Test
	def testList() {
		assertEqualsStrings("[foo, 10, true]", newArrayList("foo", 10, true).string)
	}
	
	@Test
	def testEmptyEnvironment() {
		testFiles.testSimpleRule.firstRule
		assertEqualsStrings("[]", new RuleEnvironment().string)
	}
	
	@Test
	def testEnvironmentWithMappings() {
		val env = new RuleEnvironment()
		env.add("foo", 1)
		val e = EcoreFactory::eINSTANCE.createEDataType
		e.name = "myEDataType"
		env.add(e, true)
		assertEqualsStrings("[foo <- 1, myEDataType <- true]", env.string)
	}

	@Test
	def testEnvironmentWithNext() {
		val env = new RuleEnvironment()
		env.add("foo", 1)
		val env1 = new RuleEnvironment()
		env1.add("bar", 2)
		env.setNext(env1)
		assertEqualsStrings("[foo <- 1]::[bar <- 2]", env.string)
	}
	
	@Test
	def testForCustom() {
		val eClass = EcoreFactory::eINSTANCE.createEClass
		eClass.name = "myEClass"
		assertEqualsStrings("EClass(name=myEClass)", eClass.string)
	}

	@Test
	def testForNullName() {
		val eClass = EcoreFactory::eINSTANCE.createEClass
		eClass.name = null
		assertEqualsStrings("EClass(name=null)", eClass.string)
	}

	@Test
	def testForObjectWithoutNameFeature() {
		val j = XsemanticsFactory.eINSTANCE.createJudgmentParameter
		assertEqualsStrings("JudgmentParameter", j.string)
	}
	
	@Test
	def void testProcessOnString() {
		val testString = '''
		no new line
		some new
		lines
		'''
		assertEqualsStrings(testString, testString.toString.string)
	}
	
	@Test
	def testForLongEClassifierRep() {
		val e = EcoreFactory::eINSTANCE.createEDataType
		e.name = "myEDataType with very very very very very long desc"
		assertEqualsStrings(e.name, e.string)
	}

	@Test
	def testFailedResult() {
		assertEqualsStrings("Result failed", new Result(new RuleFailedException).string)
		assertEqualsStrings("Result2 failed", new Result2(new RuleFailedException).string)
		assertEqualsStrings("Result3 failed", new Result3(new RuleFailedException).string)
	}

	@Test
	def testSuccessResult() {
		val eClass1 = EcoreFactory::eINSTANCE.createEClass
		eClass1.name = "myEClass1"
		val eClass2 = EcoreFactory::eINSTANCE.createEClass
		eClass2.name = "myEClass2"
		val eClass3 = EcoreFactory::eINSTANCE.createEClass
		eClass3.name = "myEClass3"
		
		assertEqualsStrings("Result EClass(name=myEClass1)", 
			new Result(eClass1).string
		)
		assertEqualsStrings("Result2 EClass(name=myEClass1), EClass(name=myEClass2)", 
			new Result2(eClass1, eClass2).string
		)
		assertEqualsStrings("Result3 EClass(name=myEClass1), EClass(name=myEClass2), EClass(name=myEClass3)", 
			new Result3(eClass1, eClass2, eClass3).string
		)
	}
}