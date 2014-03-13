/**
 * 
 */
package it.xsemantics.runtime;

import java.util.List;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeSet;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.util.PolymorphicDispatcher;

import com.google.inject.Inject;

/**
 * @author Lorenzo Bettini
 * 
 */
public class StringRepresentation {

	@Inject
	protected StringRepresentationPostProcessor postProcessor;

	public static final String NULL_REPRESENTATION = "null";

	private PolymorphicDispatcher<String> dispatcher = PolymorphicDispatcher
			.createForSingleTarget("stringRep", this);

	public String string(Object object) {
		// don't pass null argument to polymorphic dispatch
		// otherwise we get ambiguos methods error
		if (object == null)
			return NULL_REPRESENTATION;
		return dispatcher.invoke(object);
	}

	@SuppressWarnings("rawtypes")
	public String stringIterable(Iterable iterable) {
		StringBuffer buffer = new StringBuffer();

		for (Object object : iterable) {
			if (buffer.length() > 0)
				buffer.append(", ");
			buffer.append(string(object));
		}

		return buffer.toString();
	}

	protected String quoted(String buffer) {
		return "'" + buffer + "'";
	}

	protected <T> String stringRep(Class<T> clazz) {
		return clazz.getSimpleName();
	}

	protected String stringRep(EClassifier eClassifier) {
		return eClassifier.getName();
	}

	protected String stringRep(Object value) {
		return value.toString();
	}

	protected String withType(String typeName, String s) {
		return typeName + " " + quoted(s);
	}

	protected String stringRep(EObject eObject) {
		return postProcessor.process(stringRepForEObjectNotProcessed(eObject));
	}

	protected String stringRepForEObjectNotProcessed(EObject eObject) {
		final ICompositeNode node = NodeModelUtils.getNode(eObject);
		if (node != null)
			return NodeModelUtils.getTokenText(node);
		return stringRepForEObject(eObject);
	}

	protected String stringRepForEObject(EObject eObject) {
		EClass eClass = eObject.eClass();
		EStructuralFeature nameFeature = eClass.getEStructuralFeature("name");
		String stringRepEClass = stringRep(eClass);
		if (nameFeature != null) {
			Object eGet = eObject.eGet(nameFeature);
			return withType(stringRepEClass, string(eGet));
		} 
		else {
			EList<EStructuralFeature> eStructuralFeatures = eClass
					.getEStructuralFeatures();
			for (EStructuralFeature feature : eStructuralFeatures) {
				if (feature instanceof EAttribute) {
					EAttribute attribute = (EAttribute) feature;
					if (attribute.getEType().getName().equals("EString")) {
						Object eGet = eObject.eGet(attribute);
						if (eGet != null)
							return withType(stringRepEClass, string(eGet));
					}
				}

				if (feature instanceof EReference) {
					Object ref = eObject.eGet(feature, true);
					if (ref != null) {
						return withType(stringRepEClass, string(ref));
					}
				}
			}
		}

		return stringRepEClass;
	}

	@SuppressWarnings("rawtypes")
	protected String stringRep(List list) {
		return "[" + stringIterable(list) + "]";
	}

	protected String stringRep(RuleEnvironment environment) {
		if (environment.empty())
			return "[]";
		StringBuilder buffer = new StringBuilder();
		Set<Entry<Object, Object>> entrySet = environment.getEnvironment()
				.entrySet();
		// make sure to always use the alpha order
		Set<String> strings = new TreeSet<String>();
		for (Entry<Object, Object> entry : entrySet) {
			strings.add(string(entry.getKey()) + " <- "
					+ string(entry.getValue()));
		}
		buffer.append(strings.toString());

		if (environment.getNext() != null) {
			String nextRep = stringRep(environment.getNext());
			if (nextRep.length() > 0)
				buffer.append("::" + nextRep);
		}

		return buffer.toString();
	}

	/**
	 * @since 1.5
	 */
	protected String stringRep(Result<?> result) {
		return "Result " + (result.failed() ? "failed" :
				string(result.getValue()));
	}

	/**
	 * @since 1.5
	 */
	protected String stringRep(Result2<?,?> result) {
		return "Result2 " + (result.failed() ? "failed" :
				string(result.getFirst()) + ", " + 
				string(result.getSecond()));
	}

	/**
	 * @since 1.5
	 */
	protected String stringRep(Result3<?,?,?> result) {
		return "Result3 " + (result.failed() ? "failed" :
				string(result.getFirst()) + ", " + 
				string(result.getSecond()) + ", " + 
				string(result.getThird()));
	}
}
