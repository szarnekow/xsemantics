package it.xsemantics.dsl.tests.generator

import com.google.inject.Inject
import it.xsemantics.dsl.jvmmodel.XsemanticsJvmModelInferrer
import it.xsemantics.dsl.tests.XsemanticsInjectorProviderCustom
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.compiler.output.FakeTreeAppendable
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@InjectWith(typeof(XsemanticsInjectorProviderCustom))
@RunWith(typeof(XtextRunner))
class OldXsemanticsJvmModelInferrerTest extends XsemanticsGeneratorBaseTest {
	
	@Inject
	protected JvmModelGenerator generator
	
	@Inject
	protected extension XsemanticsJvmModelInferrer inferrer
	
	@Test
	def testIssueField() {
		assertIssueField(testFiles.testSimpleRule,
'''public final static String ECLASSEOBJECT = "it.xsemantics.test.rules.EClassEObject";'''
		)
	}
	
	// @Test does not work with Xbase 2.4.0
	def testConstructor() {
		assertConstructor(testFiles.testSimpleRule,
'''public ConstructorName() {
    init();
  }'''
		)
	}
	
	// @Test does not work with Xbase 2.4.0
	def testInit() {
		assertInit(testFiles.testSimpleRule,
'''public void init() {
    typeDispatcher = buildPolymorphicDispatcher1(
    	"typeImpl", 4, "|-", ":");
  }'''
		)
	}
	
	@Test
	def testPolymorphicDispatcherField() {
		testFiles.testJudgmentDescriptionsWith3OutputParams.
			parseAndAssertNoError.judgmentDescriptions.get(0).
				genPolymorphicDispatcherField.
				assertGeneratedMember
("private PolymorphicDispatcher<Result3<EObject,EStructuralFeature,String>> typeDispatcher;")
	}
	
	// @Test does not work with Xbase 2.4.0
	def testEntryPointMethods() {
		testFiles.testJudgmentDescriptionsWith3OutputParams.
			parseAndAssertNoError.judgmentDescriptions.get(0).
				genEntryPointMethods.
				assertGeneratedMembers
(
'''
public Result3<EObject,EStructuralFeature,String> type(final EClass c) {
    return type(new RuleEnvironment(), null, c);
  }
  
  public Result3<EObject,EStructuralFeature,String> type(final RuleEnvironment _environment_, final EClass c) {
    return type(_environment_, null, c);
  }
  
  public Result3<EObject,EStructuralFeature,String> type(final RuleEnvironment _environment_, final RuleApplicationTrace _trace_, final EClass c) {
    try {
    	return typeInternal(_environment_, _trace_, c);
    } catch (Exception _e_type) {
    	return resultForFailure3(_e_type);
    }
  }'''
)
	}

	@Test
	def testThrowExceptionMethodNull() {
		testFiles.testSimpleRule.
			parseAndAssertNoError.judgmentDescriptions.get(0).
				compileThrowExceptionMethod.assertNotNull
	}

	// @Test does not work with Xbase 2.4.0
	def testThrowExceptionMethod() {
		testFiles.testJudgmentDescriptionsWithErrorSpecification.
			parseAndAssertNoError.judgmentDescriptions.get(0).
				compileThrowExceptionMethod.
				assertGeneratedMember
(
'''
protected void typeThrowException(final String _error, final String _issue, final Exception _ex, final EObject c, final ErrorInformation[] _errorInformations) throws RuleFailedException {
    
    String _plus = ("this " + c);
    String _plus_1 = (_plus + " made an error!");
    String error = _plus_1;
    EObject source = c;
    EClass _eClass = c.eClass();
    EStructuralFeature _eContainingFeature = _eClass.eContainingFeature();
    EStructuralFeature feature = _eContainingFeature;
    throwRuleFailedException(error,
    	_issue, _ex, new ErrorInformation(source, feature));
  }'''
)
	}

	// @Test does not work with Xbase 2.4.0
	def testInternalMethod() {
		testFiles.testJudgmentDescriptionsWith2OutputParams.
			parseAndAssertNoError.judgmentDescriptions.get(0).
				compileInternalMethod.
				assertGeneratedMember
(
'''
protected Result2<EObject,EStructuralFeature> typeInternal(final RuleEnvironment _environment_, final RuleApplicationTrace _trace_, final EClass c) {
    try {
    	checkParamsNotNull(c);
    	return typeDispatcher.invoke(_environment_, _trace_, c);
    } catch (Exception _e_type) {
    	sneakyThrowRuleFailedException(_e_type);
    	return null;
    }
  }'''
)
	}
	
	// @Test does not work with Xbase 2.4.0
	def testCheckRuleInternalMethod() {
		testFiles.testCheckRule.
			parseAndAssertNoError.checkrules.get(0).
				compileInternalMethod.
				assertGeneratedMember
(
'''
protected Result<Boolean> checkEObjectInternal(final RuleApplicationTrace _trace_, final EObject obj) throws RuleFailedException {
    
    {
      EClass result = null;
      /* empty |- obj : result */
      Result<EClass> result_1 = typeInternal(emptyEnvironment(), _trace_, obj);
      checkAssignableTo(result_1.getFirst(), EClass.class);
      result = (EClass) result_1.getFirst();
      
    }
    return new Result<Boolean>(true);
  }'''
)
	}

	// @Test does not work with Xbase 2.4.0
	def testCheckRuleMethod() {
		testFiles.testCheckRule.
			parseAndAssertNoError.checkrules.get(0).
				compileCheckRuleMethods.
				assertGeneratedMembers
(
'''
public Result<Boolean> checkEObject(final EObject obj) {
    return checkEObject(null, obj);
  }
  
  public Result<Boolean> checkEObject(final RuleApplicationTrace _trace_, final EObject obj) {
    try {
    	return checkEObjectInternal(_trace_, obj);
    } catch (Exception e) {
    	return resultForFailure(e);
    }
  }'''
)
	}

	// @Test does not work with Xbase 2.4.0
	def testApplyMethodForAxiom() {
		testFiles.testSimpleAxiom.
			parseAndAssertNoError.rules.get(0).
				compileApplyMethod.
				assertGeneratedMember
(
'''
protected Result<Boolean> applyRuleEClassEObject(final RuleEnvironment G, final RuleApplicationTrace _trace_, final EClass eClass, final EObject object) throws RuleFailedException {
    
    return new Result<Boolean>(true);
  }'''
)
	}
	
	// @Test does not work with Xbase 2.4.0
	def testApplyMethodForAxiomWithExpressionInConclusion() {
		testFiles.testAxiomWithExpressionInConclusion.
			parseAndAssertNoError.rules.get(0).
				compileApplyMethod.
				assertGeneratedMember
(
'''
protected Result<EClass> applyRuleEObjectEClass(final RuleEnvironment G, final RuleApplicationTrace _trace_, final EObject object) throws RuleFailedException {
    
    EClass _eClass = object.eClass();
    return new Result<EClass>(_eClass);
  }'''
)
	}

	// @Test does not work with Xbase 2.4.0
	def testApplyMethodForRuleWithPremise() {
		testFiles.testRuleWithTwoOutputParams.
			parseAndAssertNoError.rules.get(0).
				compileApplyMethod.
				assertGeneratedMember
(
'''
protected Result2<EObject,EStructuralFeature> applyRuleEClassEObjectEStructuralFeature(final RuleEnvironment G, final RuleApplicationTrace _trace_, final EClass eClass) throws RuleFailedException {
    EObject object = null; // output parameter
    EStructuralFeature feat = null; // output parameter
    
    /* G ||- eClass : object : feat */
    Result2<EObject,EStructuralFeature> result = type2Internal(G, _trace_, eClass);
    checkAssignableTo(result.getFirst(), EObject.class);
    object = (EObject) result.getFirst();
    checkAssignableTo(result.getSecond(), EStructuralFeature.class);
    feat = (EStructuralFeature) result.getSecond();
    
    return new Result2<EObject,EStructuralFeature>(object, feat);
  }'''
)
	}
	
	// @Test does not work with Xbase 2.4.0
	def testCompileImplMethod() {
		testFiles.testSimpleRule.
			parseAndAssertNoError.rules.get(0).
				compileImplMethod.
				assertGeneratedMember
(
'''
protected Result<Boolean> typeImpl(final RuleEnvironment G, final RuleApplicationTrace _trace_, final EClass eClass, final EObject object) throws RuleFailedException {
    try {
      RuleApplicationTrace _subtrace_ = newTrace(_trace_);
      Result<Boolean> _result_ = applyRuleEClassEObject(G, _subtrace_, eClass, object);
      addToTrace(_trace_, ruleName("EClassEObject") + stringRepForEnv(G) + " |- " + stringRep(eClass) + " : " + stringRep(object));
      addAsSubtrace(_trace_, _subtrace_);
      return _result_;
    } catch (Exception e_applyRuleEClassEObject) {
      typeThrowException(ruleName("EClassEObject") + stringRepForEnv(G) + " |- " + stringRep(eClass) + " : " + stringRep(object),
      	ECLASSEOBJECT,
      	e_applyRuleEClassEObject, eClass, object, new ErrorInformation[] {new ErrorInformation(eClass), new ErrorInformation(object)});
      return null;
    }
  }'''
)
	}

	// @Test does not work with Xbase 2.4.0
	def testCompileValidatorCheckRuleMethod() {
		testFiles.testCheckRule.
			parseAndAssertNoError.checkrules.get(0).
				compileValidatorCheckRuleMethod.
				assertGeneratedMember
(
'''
@Check
  public void checkEObject(final EObject obj) {
    errorGenerator.generateErrors(this,
    	getXsemanticsSystem().checkEObject(obj),
    		obj);
  }'''
)
	}

	def assertIssueField(CharSequence prog, CharSequence expected) {
		val field = inferrer.genIssueField(prog.firstRule)
		field.assertGeneratedMember(expected)
	}
	
	def assertConstructor(CharSequence prog, CharSequence expected) {
		val cons = inferrer.genConstructor(prog.parseAndAssertNoError)
		cons.simpleName = "ConstructorName"
		cons.assertGeneratedMember(expected)
	}
	
	def assertInit(CharSequence prog, CharSequence expected) {
		val m = inferrer.genInit(prog.parseAndAssertNoError)
		m.assertGeneratedMember(expected)
	}
	
	def assertGeneratedMember(JvmMember member, CharSequence expected) {
		val a = createTestAppendable
		generator.generateMember(member, a, generatorConfig)
		assertEqualsStrings(expected, a.toString.trim)
	}
	
	def assertGeneratedMembers(Iterable<? extends JvmMember> members, CharSequence expected) {
		val a = createTestAppendable
		members.forEach [
			generator.generateMember(it, a, generatorConfig)
		]
		assertEqualsStrings(expected, a.toString.trim)
	}
	
	def createTestAppendable() {
		new FakeTreeAppendable(new ImportManager(true))
	}
	
}
