/**
 * <copyright>
 * </copyright>
 *
 * $Id: CastTest.java,v 1.1 2009-11-02 11:25:12 bettini Exp $
 */
package it.xsemantics.example.fj.tests;

import it.xsemantics.example.fj.FJStandaloneSetup;
import it.xsemantics.example.fj.fj.Expression;
import it.xsemantics.example.fj.fj.Program;
import it.xsemantics.example.fj.tests.loader.FJAbstractTests;
import it.xsemantics.example.fj.typing.FJTypeChecker;
import junit.textui.TestRunner;

/**
 * <!-- begin-user-doc --> A test case for the model object '
 * <em><b>Cast</b></em>'. <!-- end-user-doc -->
 */
public class CastTest extends FJAbstractTests {

	/**
	 * <!-- begin-user-doc --> <!-- end-user-doc -->
	 * 
	 * @generated
	 */
	public static void main(String[] args) {
		TestRunner.run(CastTest.class);
	}

	@Override
	protected void setUp() throws Exception {
		super.setUp();
		with(new FJStandaloneSetup());
	}
	
	/**
	 * test for incorrect cast
	 * @throws Exception 
	 */
	public void testCastFail() throws Exception {
		Program program = (Program) getModel("class B { } class A { } (B) new A()");
		Expression main = program.getMain();
		String errors = getInjector().getInstance(FJTypeChecker.class).typeCheck(main);
		System.out.println("errors: " + errors);
		assertTrue(errors.length() > 0);
		assertEquals("invalid cast", errors);
	}
} // CastTest
