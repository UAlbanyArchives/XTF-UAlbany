<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:session="java:org.cdlib.xtf.xslt.Session"
	extension-element-prefixes="session" exclude-result-prefixes="#all">

	<!-- ====================================================================== -->
	<!-- Common DynaXML Stylesheet                                              -->
	<!-- ====================================================================== -->

	<!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->

	<!-- ====================================================================== -->
	<!-- Import Stylesheets                                                     -->
	<!-- ====================================================================== -->

	<xsl:import href="../../../xtfCommon/xtfCommon.xsl"/>

	<!-- ====================================================================== -->
	<!-- Global Keys                                                            -->
	<!-- ====================================================================== -->

	<xsl:key name="hit-num-dynamic" match="xtf:hit" use="@hitNum"/>
	<xsl:key name="hit-rank-dynamic" match="xtf:hit" use="@rank"/>

	<!-- ====================================================================== -->
	<!-- Global Parameters                                                      -->
	<!-- ====================================================================== -->

	<!-- Path Parameters -->

	<xsl:param name="servlet.path"/>
	<xsl:param name="root.path"/>
	<xsl:param name="xtfURL" select="$root.path"/>
	<xsl:param name="dynaxmlPath" select="if (matches($servlet.path, 'org.cdlib.xtf.crossQuery.CrossQuery')) then 'org.cdlib.xtf.dynaXML.DynaXML' else 'view'"/>

	<xsl:param name="docId"/>
	<xsl:param name="docPath" select="replace($docId, '[^/]+\.xml$', '')"/>

	<!-- If an external 'source' document was specified, include it in the
      query string of links we generate. -->
	<xsl:param name="source" select="''"/>

	<xsl:variable name="sourceStr">
		<xsl:if test="$source">;source=<xsl:value-of select="$source"/></xsl:if>
	</xsl:variable>

	<xsl:param name="query.string" select="concat('docId=', $docId, $sourceStr)"/>

	<xsl:param name="doc.path"><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$query.string"/></xsl:param>

	<xsl:variable name="systemId" select="saxon:systemId()" xmlns:saxon="http://saxon.sf.net/"/>

	<xsl:param name="doc.dir">
		<xsl:choose>
			<xsl:when test="starts-with($systemId, 'http://')">
				<xsl:value-of select="replace($systemId, '/[^/]*$', '')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($xtfURL, 'data/', $docPath)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:param name="figure.path" select="concat($doc.dir, '/figures/')"/>

	<xsl:param name="pdf.path" select="concat($doc.dir, '/pdfs/')"/>

	<!-- navigation parameters -->

	<xsl:param name="doc.view" select="'0'"/>

	<xsl:param name="toc.depth" select="1"/>

	<xsl:param name="anchor.id" select="'0'"/>

	<xsl:param name="set.anchor" select="'0'"/>

	<xsl:param name="chunk.id"/>

	<xsl:param name="toc.id"/>

	<!-- search parameters -->

	<xsl:param name="query"/>
	<xsl:param name="query-join"/>
	<xsl:param name="query-exclude"/>
	<xsl:param name="sectionType"/>

	<xsl:param name="search">
		<xsl:if test="$query">
			<xsl:value-of select="concat(';query=', replace($query, ';', '%26'))"/>
		</xsl:if>
		<xsl:if test="$query-join">
			<xsl:value-of select="concat(';query-join=', $query-join)"/>
		</xsl:if>
		<xsl:if test="$query-exclude">
			<xsl:value-of select="concat(';query-exclude=', $query-exclude)"/>
		</xsl:if>
		<xsl:if test="$sectionType">
			<xsl:value-of select="concat(';sectionType=', $sectionType)"/>
		</xsl:if>
	</xsl:param>

	<xsl:param name="hit.rank" select="'0'"/>

	<!-- Branding Parameters -->

	<xsl:param name="brand" select="'default'"/>

	<xsl:variable name="brand.file">
		<xsl:choose>
			<xsl:when test="$brand != ''">
				<xsl:copy-of select="document(concat('../../../../brand/',$brand,'.xml'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="document('../../../../brand/default.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:param name="brand.links" select="$brand.file/brand/dynaxml.links/*" xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
	<xsl:param name="brand.header" select="$brand.file/brand/dynaxml.header/*" xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
	<xsl:param name="brand.footer" select="$brand.file/brand/footer/*" xpath-default-namespace="http://www.w3.org/1999/xhtml"/>

	<!-- Special Robot Parameters -->

	<xsl:param name="http.user-agent"/>
	<!-- WARNING: Inclusion of 'Wget' is for testing only, please remove before going into production -->
	<xsl:param name="robots" select="'Googlebot|Slurp|msnbot|Teoma|Wget'"/>

	<!-- ====================================================================== -->
	<!-- Button Bar Templates                                                   -->
	<!-- ====================================================================== -->

	<xsl:template name="bbar">
		<!-- Navigation -->
		<nav class="navbar navbar-inverse navbar-top" role="navigation">
			<div class="container">
				<!-- Brand and toggle get grouped for better mobile display -->
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<!--<a class="navbar-brand" href="http://library.albany.edu/archive/"><img src="icons/ua/mainLogo.png" height="75px" /></a>-->
					<div class="navbar-brand">
						<a class="logo" href="http://library.albany.edu/archive/"><img src="icons/ua/mainLogo.png" /></a>
						<a class="ualbany" href="http://www.albany.edu"><img src="icons/ua/ualbany.png" /></a>
						<a class="smallLogo" href="http://library.albany.edu/archive/"><img src="icons/ua/mainLogo.png" /></a>
					</div>
				</div>
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav" id="topNavMenu">
						<!--<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">UAlbany <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="http://www.albany.edu/">UAlbany, SUNY</a></li>
								<li><a href="http://library.albany.edu/">University Libraries</a></li>
							</ul>
						</li>-->
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Collections <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="search">About Collections</a></li>
								<li><a href="http://library.albany.edu/archive/apap">NY State Modern Political Archive</a></li>
								<li><a href="http://library.albany.edu/archive/ndpa">National Death Penalty Archive</a></li>
								<li><a href="http://library.albany.edu/archive/ger">German Intellectual Émigré</a></li>
								<li><a href="http://library.albany.edu/archive/ua">University Archives</a></li>
								<li><a href="http://library.albany.edu/archive/mathes">Mathes Childrens Literature</a></li>
								<li><a href="http://library.albany.edu/archive/manuscript">Rare Books and Manuscripts</a></li>
								<li><a href="http://library.albany.edu/archive/collections/alpha">A-Z Complete List of Collections</a></li>
								<li><a href="http://library.albany.edu/archive/collections/subject">Subject Guides to Collections</a></li>
							</ul>
						</li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Digital Selections <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="http://library.albany.edu/archive/digitalcollections">About Digital Selections</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/UALBANYSCA~14~14">Digital Photograph Collections (LUNA)</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/s/uc9c1q">University Photographs</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/view/search;JSESSIONID=2b6136d9-4163-47bb-bdb7-152ea22a99fa?sort=Archive_Collection%2CDate%2CTitle%2CSubject&amp;q=Creator%3D%22United+University+Professions+%28UUP%29%22&amp;pgs=50&amp;res=1">United University Professions</a></li>
								<li><a href="http://library.albany.edu/archive/milnedigitalcollections">Milne School</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/view/search?q==%22WAMC%22&amp;sort=Archive_Collection,Date,Title,Subject">WAMC Northeast Public Radio</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/view/search?QuickSearchA=QuickSearchA&amp;q=marcia+brown&amp;search=Search">Marcia Brown</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/view/search?QuickSearchA=QuickSearchA&amp;q=CSEA&amp;sort=Archive_Collection%2CDate%2CTitle%2CSubject&amp;search=Search">The Civil Service Employees Association (CSEA)</a></li>
								<li><a href="http://luna.albany.edu/luna/servlet/view/search?QuickSearchA=QuickSearchA&amp;q=Norman+Studer&amp;sort=Archive_Collection%2CDate%2CTitle%2CSubject&amp;search=Search">Norman Studer</a></li>
								<li><a href="http://library.albany.edu/speccoll/findaids/apap015.htm#series5">CSEA Newspaper Archive</a></li>
								<li><a href="http://library.albany.edu/speccoll/findaids/eresources/findingaids/ua809.html">Albany Student Newspaper Archive</a></li>
							</ul>
						</li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Exhibits <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="http://library.albany.edu/archive/chronology">Chronological History of UAlbany</a></li>
								<li><a href="http://library.albany.edu/archive/seeger">Remembering Pete Seeger</a></li>
								<li><a href="http://library.albany.edu/archive/exhibitmilne">The Milne School Murals</a></li>
								<li><a href="http://library.albany.edu/speccoll/campusbuildings/index.htm">Campus Buildings Historical Tour</a></li>
								<li><a href="http://library.albany.edu/speccoll/marciabrown/index.htm">Marcia Brown Exhibit and Resource Website</a></li>
								<li><a href="http://library.albany.edu/speccoll/stockingBrown/">Patricia Stocking Brown</a></li>
								<li><a href="http://library.albany.edu/speccoll/mural/">University Historical Murals</a></li>
								<li><a href="http://library.albany.edu/speccoll/secretlives/index.htm">The Secret Lives of Toys and Their Friends</a></li>
								<li><a href="http://library.albany.edu/speccoll/stone/index.htm">Edward Durell Stone and the Building of the Uptown Campus</a></li>
								<li><a href="http://library.albany.edu/archive/exhibits">More...</a></li>
							</ul>
						</li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">University Records <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="http://library.albany.edu/archive/ua/transferform">Transfer Records to the University Archives</a></li>
								<li><a href="http://library.albany.edu/archive/universityarchives">FAQ</a></li>
								<li><a href="http://library.albany.edu/archive/UniversityArchives/ANTS">About ANTS: Archives Network Transfer System</a></li>
								<li><a href="http://library.albany.edu/archive/ua/matrix">University Records Charts</a></li>
								<li><a href="#">About SUNY Records Laws</a></li>
								<li><a href="https://wiki.albany.edu/display/public/askit/Information+Security+Domains%2C+Supporting+Protocols+and+Procedures">About CIO Data Classification System</a></li>
							</ul>
						</li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">About <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="http://library.albany.edu/archive/rules">How to Use Collections for Research</a></li>
								<li><a href="http://library.albany.edu/archive/directions">Hours and Directions</a></li>
								<li><a href="http://library.albany.edu/archive/contact">Staff</a></li>
								<li><a href="http://library.albany.edu/archive/grenander">About M.E. Grenander</a></li>
								<li><a href="http://library.albany.edu/archive/manual">Accessioning and Processing Manual</a></li>
								<li><a href="http://library.albany.edu/archive/citation">Citation Guide for Unpublished Materials</a></li>
								<li><a href="http://library.albany.edu/archive/policy">Collection Development Policy</a></li>
								<li><a href="http://library.albany.edu/archive/copyright">Copyright Notice</a></li>
								<li><a href="http://liblogs.albany.edu/grenander/">Department Blog</a></li>
								<li><a href="http://library.albany.edu/archive/historicalresources/">Find Other Historical Repositories</a></li>
								<li><a href="http://library.albany.edu/archive/research_room">Marcia Brown Research Room</a></li>
								<li><a href="http://library.albany.edu/speccoll/findaids/eresources/drupal/publish.pdf">Permission to Publish Form</a></li>
							</ul>
						</li>
						<li>
							<a href="http://library.albany.edu/archive/reference">Contact</a>
						</li>
					
					<div class="col-sm-3 col-md-3 pull-right" id="searchBox">
						<form id="searchForm" class="navbar-form" role="search" action="search">
							<div class="input-group">
								<input id="searchAll" type="text" class="form-control" placeholder="Search" name="keyword" value=""/>
								<input type="text" class="form-control" placeholder="Search this Collection" name="query" id="srch-term" disabled="disabled"/>
								<input id="srch-termValue" type="hidden" name="docId" value="{$docId}" disabled="disabled"/>

								
								<div class="input-group-btn">
									<div class="dropdown dropdown-lg">
										<div class="dropdown" id="searchSelect">
											<button id="searchBtn" class="btn btn-default dropdown-toggle"  type="button"  data-toggle="dropdown">
											 <span class="caret"></span></button>
											 <div class="dropdown-menu">
												<div class="radio">
												  <label><input type="radio" name="optradio" value="1" checked="checked" />Search All</label>
												 </div>
												 <div class="radio">
												  <label><input type="radio" name="optradio" value="2" />Search Collection</label>
												</div>
											  </div>
										</div>
									</div>
								</div>
								<div class="input-group-btn">
									<button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
								</div>
							</div>
						</form>
					</div>
					</ul>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<xsl:call-template name="toc">
				<xsl:with-param name="aboutNodes" select="archdesc/bioghist | archdesc/scopecontent | archdesc/phystech | archdesc/arrangement | archdesc/did/langmaterial | archdesc/relatedmaterial | archdesc/separatedmaterial | archdesc/odd"/>
				<xsl:with-param name="historyNodes" select="archdesc/custodhist | archdesc/altformavail | archdesc/acqinfo |eadheader/filedesc/titlestmt/author | archdesc/appraisal | archdesc/accruals | eadheader/profiledesc | eadheader/revisiondesc"/>
				<xsl:with-param name="accessNodes" select="archdesc/accessrestrict | archdesc/userestrict | archdesc/prefercite"/>
			</xsl:call-template>
		</nav>

		<!--<xsl:call-template name="translate">
         <xsl:with-param name="resultTree">
            <html xml:lang="en" lang="en">
               <head>
                  <title>
                     <xsl:value-of select="$doc.title"/>
                  </title>
                  <link rel="stylesheet" type="text/css" href="{$css.path}bbar.css"/>
                  <link rel="shortcut icon" href="icons/default/faviconU" />


               </head>
               <body>
                  <div class="bbar">
                     <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                           <td colspan="3" align="center">
                              <xsl:copy-of select="$brand.header"/>
                           </td>
                        </tr>
                        <tr>
                           <td class="left">
                              <a href="{$xtfURL}search" target="_top">Home</a><xsl:text> | </xsl:text>
                              <xsl:choose>
                                 <xsl:when test="session:getData('queryURL')">
                                    <a href="{session:getData('queryURL')}" target="_top">Return to Search Results</a>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <span class="notActive">Return to Search Results</span>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </td>
                           <td width="34%" class="center">
                              <form action="{$xtfURL}{$dynaxmlPath}" target="_top" method="get">
                                 <input name="query" type="text" size="15"/>
                                 <input type="hidden" name="docId" value="{$docId}"/>
                                 <input type="hidden" name="chunk.id" value="{$chunk.id}"/>
                                 <input type="submit" value="Search this Item"/>
                              </form>
                           </td>
                           <td class="right">
                              <a>
                                 <xsl:attribute name="href">javascript://</xsl:attribute>
                                 <xsl:attribute name="onclick">
                                    <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/><xsl:text>?docId=</xsl:text><xsl:value-of
                                       select="$docId"/><xsl:text>;doc.view=citation</xsl:text><xsl:text>','popup','width=800,height=400,resizable=yes,scrollbars=no')</xsl:text>
                                 </xsl:attribute>
                                 <xsl:text>Citation</xsl:text>
                              </a>
                              <xsl:text> | </xsl:text>
                              <a href="{$doc.path}&#038;doc.view=print;chunk.id={$chunk.id}" target="_top">Print View</a>
                              <xsl:text> | </xsl:text>
                              <a href="javascript://" onclick="javascript:window.open('/xtf/search?smode=getLang','popup','width=500,height=200,resizable=no,scrollbars=no')">Choose Language</a>
                           </td>
                        </tr>
                     </table>
                  </div>
               </body>
            </html>
         </xsl:with-param>
      </xsl:call-template>-->
	</xsl:template>

	<!-- ====================================================================== -->
	<!-- Citation Template                                                      -->
	<!-- ====================================================================== -->

	<xsl:template name="citation">

		<html xml:lang="en" lang="en">
			<head>
				<title>
					<xsl:value-of select="$doc.title"/>
				</title>
				<link rel="stylesheet" type="text/css" href="{$css.path}bbar.css"/>
				<link rel="shortcut icon" href="icons/ua/mainLogo.ico"/>
			</head>
			<body>
				<xsl:copy-of select="$brand.header"/>
				<div class="container">
					<h2>Citation</h2>
					<div class="citation">
						<p><xsl:value-of select="/*/*:meta/*:creator[1]"/>. <xsl:value-of select="/*/*:meta/*:title[1]"/>. <xsl:value-of select="/*/*:meta/*:year[1]"/>.<br/> [<xsl:value-of
								select="concat($xtfURL,$dynaxmlPath,'?docId=',$docId)"/>]</p>
						<a>
							<xsl:attribute name="href">javascript://</xsl:attribute>
							<xsl:attribute name="onClick">
								<xsl:text>javascript:window.close('popup')</xsl:text>
							</xsl:attribute>
							<span class="down1">Close this Window</span>
						</a>
					</div>
				</div>
			</body>
		</html>

	</xsl:template>

	<!-- ====================================================================== -->
	<!-- Robot Template                                                         -->
	<!-- ====================================================================== -->

	<xsl:template name="robot">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<title>
					<xsl:value-of select="//xtf:meta/title[1]"/>
				</title>
				<link rel="shortcut icon" href="icons/ua/mainLogo.ico"/>

			</head>
			<body>
				<div>
					<xsl:apply-templates select="//text()" mode="robot"/>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="text()" mode="robot">
		<xsl:value-of select="."/>
		<xsl:text> </xsl:text>
	</xsl:template>

</xsl:stylesheet>
