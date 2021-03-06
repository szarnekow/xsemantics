/*
* generated by Xtext
*/
package it.xsemantics.dsl.ui.labeling

import com.google.inject.Inject
import it.xsemantics.dsl.util.XsemanticsUtils
import it.xsemantics.dsl.xsemantics.AbstractFieldDefinition
import it.xsemantics.dsl.xsemantics.AuxiliaryDescription
import it.xsemantics.dsl.xsemantics.AuxiliaryFunction
import it.xsemantics.dsl.xsemantics.Axiom
import it.xsemantics.dsl.xsemantics.CheckRule
import it.xsemantics.dsl.xsemantics.JudgmentDescription
import it.xsemantics.dsl.xsemantics.Rule
import it.xsemantics.dsl.xsemantics.RuleWithPremises
import it.xsemantics.dsl.xsemantics.XsemanticsSystem
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.ui.labeling.XbaseLabelProvider

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class XsemanticsLabelProvider extends XbaseLabelProvider {

	@Inject extension XsemanticsUtils

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	def text(Rule rule) {
		val judgmentDescription = rule.getJudgmentDescription();
		if (judgmentDescription == null)
			return rule.getName;
		return rule.getName()
				+ " (" + Strings.emptyIfNull(judgmentDescription.getName()) + ")";
	}

	def text(CheckRule rule) {
		return rule.getName();
	}

	def text(AuxiliaryFunction aux) {
		val desc = aux.getAuxiliaryDescription();
		if (desc == null)
			return aux.getName;
		return aux.getName() + " (" + Strings.emptyIfNull(desc.getName()) + ")";
	}

	def image(Axiom axiom) {
		return "axiom.gif";
	}

	def image(RuleWithPremises rule) {
		return "rule.gif";
	}

	def image(CheckRule rule) {
		return "checkrule.gif";
	}

	def image(XsemanticsSystem ts) {
		return "system.gif";
	}

	def image(JudgmentDescription desc) {
		return "judgment.gif";
	}

	def image(AuxiliaryFunction aux) {
		return "auxfun.gif";
	}

	def image(AuxiliaryDescription aux) {
		return "auxdesc.gif";
	}

	def image(AbstractFieldDefinition f) {
		return "field_public_obj.gif";
	}
}
