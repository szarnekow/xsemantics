/*
 * generated by Xtext
 */
package it.xsemantics.dsl.generator

import com.google.inject.Inject
import com.google.inject.Provider
import it.xsemantics.dsl.xsemantics.XsemanticsSystem
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

import static extension org.eclipse.xtext.xbase.lib.IteratorExtensions.*

class XsemanticsGenerator implements IGenerator {
	
	@Inject extension XsemanticsGeneratorExtensions
	
	@Inject Provider<XsemanticsSystemGenerator> systemGeneratorProvider
	
	@Inject Provider<XsemanticsValidatorGenerator> validatorGeneratorProvider
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for(ts: resource.allContents.toIterable.filter(typeof(XsemanticsSystem))) {
			fsa.generateFile(
				ts.toJavaClassFile,
				systemGeneratorProvider.get.compile(ts))
			fsa.generateFile(
				ts.toValidatorJavaClassFile,
				validatorGeneratorProvider.get.compile(ts))
		}
	}
}
