<%@ page import="java.util.NoSuchElementException" %>
<%@ page import="net.sf.okapi.lib.segmentation.*" %>
<%@ page import="pangolin.objects.AnnotatedRule" %>
<%
	
	SRXDocument srxDoc = null;
	String fileName = null;
	String languageRuleName = null;
	int selectedRuleIndex = -1; // -1 indicates not set
	AnnotatedRule editingRule = null;
	
	if (pageRequiresDoc) {
		//get the SRX document from session variable
		try {
			srxDoc = (SRXDocument)request.getSession().getAttribute("srxDoc");
		} catch (ClassCastException e) {
			srxDoc = null;
		}
		if (srxDoc == null) {
			response.sendRedirect("chooseFile.jsp?error=no-document-loaded");
			return;
		}
		
		//get the filename from session variable
		try {
			fileName = (String)request.getSession().getAttribute("file-name");
		} catch (ClassCastException e) {
			fileName = null;
		}
		
		//get the current language rule name from the session variable
		//may be null
		languageRuleName = request.getParameter("language-rule");
		if (languageRuleName != null) {
			request.getSession().setAttribute("languageRuleName", languageRuleName);
		}
		if (languageRuleName == null) {
			try {
				languageRuleName = (String)request.getSession().getAttribute("languageRuleName");
			} catch (ClassCastException e) {
				languageRuleName = null;
			}
		}
		if (languageRuleName == null) {
			//try setting to first available language rule group
			try {
				languageRuleName = srxDoc.getAllLanguageRules().keySet().iterator().next();
			} catch (NoSuchElementException e) {
				languageRuleName = null;
			} catch (NullPointerException e) {
				languageRuleName = null;
			}
			if (languageRuleName != null) {
				request.getSession().setAttribute("languageRuleName", languageRuleName);
			}
		}
		
		//try to load from request parameter (most recent value)
		try {
			selectedRuleIndex = Integer.parseInt(request.getParameter("rule-index"));
			request.getSession().setAttribute("selectedRuleIndex", selectedRuleIndex);
		} catch (NumberFormatException e) {
			selectedRuleIndex = -1;
		}
		//if it wasn't in the request, use the session variable
		if (selectedRuleIndex == -1) {
			try {
				selectedRuleIndex = (Integer)request.getSession().getAttribute("selectedRuleIndex");
			} catch (NumberFormatException e) {
				selectedRuleIndex = -1;
			} catch (NullPointerException e) {
				selectedRuleIndex = -1;
			}
		}
		
		//load the rule that is currently being edited
		try {
			editingRule = (AnnotatedRule)request.getSession().getAttribute("editingRule");
		} catch (ClassCastException e) {
			editingRule = null;
		}
	}
%>