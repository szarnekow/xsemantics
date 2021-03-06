package it.xsemantics.example.fj.tests

import com.google.inject.Inject
import it.xsemantics.example.fj.FJInjectorProvider
import it.xsemantics.example.fj.fj.Program
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(FJInjectorProvider))
class FjValidatorTests {
	
	@Inject extension ParseHelper<Program>
	
	@Inject extension ValidationTestHelper
	
	@Test
	def void testUnresolvedReferenceInMain() {
		'''
		class A { }
		
		new A().f
		'''.parse.validate => [
		
		// this is the only error that we should get
		// the rest of the type system does not detect other errors
		'''Couldn't resolve reference to Member 'f'.'''.
			toString.assertEquals(map[message].join("\n"))
		
		]

	}
	

}