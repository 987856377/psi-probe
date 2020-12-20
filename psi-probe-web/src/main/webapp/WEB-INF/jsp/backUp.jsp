<%--

    Licensed under the GPL License. You may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      https://www.gnu.org/licenses/old-licenses/gpl-2.0.html

    THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
    WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR
    PURPOSE.

--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib uri="https://github.com/psi-probe/psi-probe/jsp/tags" prefix="probe" %>

<html>
<head>
    <title><spring:message code="probe.jsp.title.backup"/></title>
    <script type="text/javascript" src="<c:url value='/js/prototype.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/scriptaculous/scriptaculous.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/func.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/behaviour.js'/>"></script>
</head>

<body>

<c:set var="navTabbackUp" value="active" scope="request"/>

<script type="text/javascript">
    function toggleContext(idx, fileName, back) {
        var status = $(idx);
        status.update('<img border="0" src="${pageContext.request.contextPath}<spring:theme code="progressbar_editnplace.gif"/>"/>');
        var data = 'fileName=' + encodeURIComponent(fileName) + '&back=' + back;
        new Ajax.Updater(status, '/backup/reBackUp.ajax', {
            method: 'get',
            asynchronous: true,
            parameters: data,
            onComplete: function (response) {
                updateStatusClass(status, response.responseText);
            }
        });
        return false;
    }

    function updateStatusClass(status, responseText) {
        if (responseText.include("1")) {
            status.addClassName('okValue').removeClassName('errorValue');
            status.update("成功");
        } else if (responseText.include("2")) {
            status.update("失败");
            status.addClassName('errorValue').removeClassName('okValue');
        }
    }
</script>

<div class="blockContainer">

    <div id="help" class="helpMessage" style="display: none;">
        <div class="ajax_activity"></div>
    </div>

    <c:if test="${! empty errorMessage}">
        <div class="errorMessage">
            <p>
                    ${errorMessage}
            </p>
        </div>
    </c:if>

    <c:if test="${! empty successMessage}">
        <div id="successMessage">
                ${successMessage}
        </div>
    </c:if>
    <display:table class="genericTbl" name="apps" uid="app" style="border-spacing:0;border-collapse:separate;"
                   requestURI=""
                   defaultorder="ascending" cellpadding="0">
        <display:column sortable="true" titleKey="probe.jsp.backUp.col.backup.num">
            ${app_rowNum}
        </display:column>
        <display:column sortable="true" titleKey="probe.jsp.backUp.col.backup.name">
            <a href="<c:url value='/appsummary.htm'><c:param name='webapp' value='${app.name}'/><c:param name='size'><c:out value='${param.size}'/></c:param></c:url>">
                    ${app.name}
            </a>
        </display:column>
        <display:column sortable="true" titleKey="probe.jsp.backUp.col.backup.time">
            ${app.lastModified()}
        </display:column>
        <display:column titleKey="probe.jsp.backUp.col.backup.method">
            <a onclick="return toggleContext('rs_${app_rowNum}', '${app.name}', 'true');"
               title="<spring:message code='probe.jsp.applications.title.status.up' arguments='${app.name}'/>">
							<span style="display: block" class="okValue" id="rs_${app_rowNum}">
								<spring:message code="probe.jsp.backUp.withBack"/>
							</span>
            </a>
        </display:column>
        <display:column titleKey="probe.jsp.backUp.col.backup.method">
            <a onclick="return toggleContext('rs2_${app_rowNum}', '${app.name}', 'false');"
               title="<spring:message code='probe.jsp.applications.title.status.up' arguments='${app.name}'/>">
							<span style="display: block" class="okValue" id="rs2_${app_rowNum}">
								<spring:message code="probe.jsp.backUp.withoutBack"/>
							</span>
            </a>
        </display:column>
    </display:table>

    <script type="text/javascript">
        setupHelpToggle('<c:url value="/help/applications.ajax"/>');
    </script>
</div>
</body>
</html>
