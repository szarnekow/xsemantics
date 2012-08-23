/*
 * generated by Xtext
 */
package it.xsemantics.dsl.scoping;

import static org.eclipse.xtext.xbase.lib.IterableExtensions.filter;
import static org.eclipse.xtext.xbase.lib.IterableExtensions.head;
import it.xsemantics.dsl.util.XsemanticsUtils;
import it.xsemantics.dsl.xsemantics.ExpressionInConclusion;
import it.xsemantics.dsl.xsemantics.Rule;
import it.xsemantics.dsl.xsemantics.RuleInvocation;
import it.xsemantics.dsl.xsemantics.RuleParameter;

import java.util.List;
import java.util.Set;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.xbase.XBlockExpression;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.XVariableDeclaration;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.jvmmodel.ILogicalContainerProvider;
import org.eclipse.xtext.xbase.scoping.LocalVariableScopeContext;
import org.eclipse.xtext.xbase.scoping.XbaseScopeProvider;
import org.eclipse.xtext.xbase.scoping.featurecalls.IValidatedEObjectDescription;
import org.eclipse.xtext.xbase.scoping.featurecalls.JvmFeatureScope;
import org.eclipse.xtext.xbase.validation.IssueCodes;

import com.google.common.collect.Lists;
import com.google.inject.Inject;

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#scoping on
 * how and when to use it
 * 
 */
@SuppressWarnings("restriction")
public class XsemanticsScopeProvider extends XbaseScopeProvider {
	@Inject
	protected XsemanticsUtils utils;

	@Inject
	protected IJvmModelAssociations associations;

	@Inject
	private ILogicalContainerProvider logicalContainerProvider;

	@Override
	protected IScope createLocalVarScope(IScope parentScope,
			LocalVariableScopeContext scopeContext) {
		if (scopeContext == null || scopeContext.getContext() == null)
			return parentScope;
		EObject context = scopeContext.getContext();

		// The inferrer associates to a Rule both field(s) and methods
		// and we need the method (i.e., the JvmOperation) to actually
		// build a correct scope
		JvmOperation jvmOperation = getJvmOperationAssociatedToSourceElement(context);

		if (jvmOperation == null)
			return super.createLocalVarScope(parentScope, scopeContext);
		else {
			if (jvmOperation.getDeclaringType() != null) {
				JvmDeclaredType declaredType = jvmOperation.getDeclaringType();
				if (!jvmOperation.isStatic()) {
					parentScope = createLocalVarScopeForJvmDeclaredType(
							declaredType, parentScope);
				}
			}
			return createLocalVarScopeForJvmOperation(jvmOperation, parentScope);
		}

	}
	
	@Override
	protected JvmDeclaredType getContextType(EObject obj) {
		// the context type of an ExpressionInConclusion is the same
		// as the inferred class of the containing Rule
		// this way, visibility works correctly and
		// an ExpressionInConclusion can access private injected fields
		if (obj instanceof ExpressionInConclusion) {
			return super.getContextType(logicalContainerProvider
					.getLogicalContainer(utils.containingRule(obj)));
		}
		return super.getContextType(obj);
	}

	private JvmOperation getJvmOperationAssociatedToSourceElement(
			EObject context) {
		EObject sourceElement = associations.getPrimarySourceElement(context);

		if (sourceElement == null)
			return null;

		Set<EObject> jvmElements = associations.getJvmElements(sourceElement);
		JvmOperation jvmOperation = head(filter(jvmElements, JvmOperation.class));
		return jvmOperation;
	}

	@Override
	protected IScope createLocalVarScopeForBlock(XBlockExpression block,
			int indexOfContextExpressionInBlock, boolean referredFromClosure,
			IScope parentScope) {
		parentScope = super.createLocalVarScopeForBlock(block,
				indexOfContextExpressionInBlock, referredFromClosure,
				parentScope);
		List<IValidatedEObjectDescription> descriptions = Lists.newArrayList();
		EObject container = block.eContainer();
		// add the output parameters as variable declarations
		if (container instanceof Rule) {
			Rule rule = (Rule) container;
			addRuleParamsInDescriptions(utils.outputParams(rule), descriptions,
					referredFromClosure);
		}
		// add the variable declarations inside rule invocations
		for (int i = 0; i < indexOfContextExpressionInBlock; i++) {
			XExpression expression = block.getExpressions().get(i);
			if (expression instanceof RuleInvocation) {
				RuleInvocation ruleInvocation = (RuleInvocation) expression;
				List<XVariableDeclaration> variableDeclarations = utils
						.getVariableDeclarations(ruleInvocation);
				for (XVariableDeclaration varDecl : variableDeclarations) {
					addVariableDeclaration(descriptions, varDecl,
							referredFromClosure);
				}
			}
		}
		if (descriptions.isEmpty())
			return parentScope;
		return new JvmFeatureScope(parentScope, "XBlockExpression",
				descriptions);
	}

	private void addRuleParamsInDescriptions(List<RuleParameter> params,
			List<IValidatedEObjectDescription> descriptions,
			boolean referredFromClosure) {
		for (RuleParameter p : params) {
			if (p.getParameter() != null && p.getParameter().getName() != null) {
				IValidatedEObjectDescription desc = createLocalVarDescription(p
						.getParameter());
				if (referredFromClosure)
					desc.setIssueCode(IssueCodes.INVALID_MUTABLE_VARIABLE_ACCESS);
				descriptions.add(desc);
			}
		}
	}

	protected void addVariableDeclaration(
			List<IValidatedEObjectDescription> descriptions,
			XVariableDeclaration varDecl, boolean referredFromClosure) {
		if (varDecl.getName() != null) {
			IValidatedEObjectDescription desc = createLocalVarDescription(varDecl);
			if (referredFromClosure && varDecl.isWriteable())
				desc.setIssueCode(IssueCodes.INVALID_MUTABLE_VARIABLE_ACCESS);
			descriptions.add(desc);
		}
	}
}
