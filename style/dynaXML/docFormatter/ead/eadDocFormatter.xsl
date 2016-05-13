<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xtf="http://cdlib.org/xtf" xmlns:session="java:org.cdlib.xtf.xslt.Session"
	extension-element-prefixes="session" exclude-result-prefixes="#all">

	<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- EAD dynaXML Stylesheet                                                 -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

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

	<!-- 
      NOTE: This is rough adaptation of the EAD Cookbook stylesheets to get them 
      to work with XTF. It should in no way be considered a production interface 
   -->

	<!-- ====================================================================== -->
	<!-- Import Common Templates                                                -->
	<!-- ====================================================================== -->

	<xsl:import href="../common/docFormatterCommon.xsl"/>

	<!-- ====================================================================== -->
	<!-- Output Format                                                          -->
	<!-- ====================================================================== -->

	<xsl:output method="xhtml" indent="yes" encoding="UTF-8" media-type="text/html; charset=UTF-8"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		exclude-result-prefixes="#all" omit-xml-declaration="yes"/>

	<xsl:output name="frameset" method="xhtml" indent="no" encoding="UTF-8"
		media-type="text/html; charset=UTF-8" doctype-public="HTML" omit-xml-declaration="yes"
		exclude-result-prefixes="#all"/>

	<!-- ====================================================================== -->
	<!-- Strip Space                                                            -->
	<!-- ====================================================================== -->

	<xsl:strip-space elements="*"/>


	<!-- ====================================================================== -->
	<!-- Included Stylesheets                                                   -->
	<!-- ====================================================================== -->

	<xsl:include href="eadcbs7.xsl"/>
	<xsl:include href="parameter.xsl"/>
	<xsl:include href="search.xsl"/>

	<!-- ====================================================================== -->
	<!-- Define Keys                                                            -->
	<!-- ====================================================================== -->

	<xsl:key name="chunk-id"
		match="*[parent::archdesc or matches(local-name(), '^(c|c[0-9][0-9])$')][@id]" use="@id"/>

	<!-- ====================================================================== -->
	<!-- EAD-specific parameters                                                -->
	<!-- ====================================================================== -->

	<!-- If a query was specified but no particular hit rank, jump to the first hit 
        (in document order) 
   -->
	<xsl:param name="hit.num" select="'0'"/>

	<xsl:param name="hit.rank">
		<xsl:choose>
			<xsl:when test="$hit.num != '0'">
				<xsl:value-of select="key('hit-num-dynamic', string($hit.num))/@rank"/>
			</xsl:when>
			<xsl:when test="$query and not($query = '0')">
				<xsl:value-of select="key('hit-num-dynamic', '1')/@rank"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'0'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<!-- To support direct links from snippets, the following two parameters must check value of $hit.rank -->
	<xsl:param name="chunk.id">
		<xsl:choose>
			<xsl:when test="$hit.rank != '0'">
				<xsl:call-template name="findHitChunk">
					<xsl:with-param name="hitNode"
						select="key('hit-rank-dynamic', string($hit.rank))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'0'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<!-- ====================================================================== -->
	<!-- Root Template                                                          -->
	<!-- ====================================================================== -->

	<xsl:template match="/ead">
		<xsl:choose>
			<!-- robot solution -->
			<xsl:when test="matches($http.user-agent,$robots)">
				<xsl:call-template name="robot"/>
			</xsl:when>
			<!-- Creates the button bar.-->
			<xsl:when test="$doc.view = 'bbar'">
				<xsl:call-template name="bbar"/>
			</xsl:when>
			<!-- Creates the basic table of contents.-->
			<xsl:when test="$doc.view = 'toc'">
				<xsl:call-template name="toc"/>
			</xsl:when>
			<!-- Creates the body of the finding aid.-->
			<xsl:when test="$doc.view = 'content'">
				<xsl:call-template name="body"/>
			</xsl:when>
			<!-- print view -->
			<xsl:when test="$doc.view='print'">
				<xsl:call-template name="print"/>
			</xsl:when>
			<!-- citation -->
			<xsl:when test="$doc.view='citation'">
				<xsl:call-template name="citation"/>
			</xsl:when>

			<!-- Creates the basic frameset.-->
			<xsl:otherwise>
				<xsl:call-template name="frameset"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ====================================================================== -->
	<!-- Frameset Template                                                      -->
	<!-- ====================================================================== -->

	<xsl:template name="frameset">
		<xsl:result-document format="frameset" exclude-result-prefixes="#all">
			<html xml:lang="en" lang="en">
				<head>
					<link rel="shortcut icon" href="icons/ua/mainLogo.ico"/>
					<meta name="viewport" content="width=device-width, initial-scale=1"/>
					<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
					<!-- bootstrap -->
					<link rel="stylesheet" href="css/bootstrap.min.css"/>
					<link rel="stylesheet" href="css/simple-sidebar.css"/>
					<link rel="stylesheet" href="css/font-awesome.min.css"/>
					<link rel="stylesheet" href="css/awesome-bootstrap-checkbox.css"/>
					<link rel="stylesheet" href="css/ua/headerNavbar.css"/>
					<link rel="stylesheet" href="css/ua/sideNavbar.css"/>
					<link rel="stylesheet" href="css/ua/collectionLevel.css"/>
					<link rel="stylesheet" href="css/default/sidebar.css"/>
					<script type="text/javascript" src="js/bootstrap.min.js"/>
					<!--[if lt IE 9]>
      					<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      					<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    				<![endif]-->
					<!--<link rel="stylesheet" type="text/css" href="{$css.path}ead.css"/>-->
					<!--<xsl:call-template name="metadata"/>-->
					<script type="text/javascript" src="script/leftNav.js"></script>
					<title>
						<!--<xsl:value-of select="archdesc/did/unittitle/text()"/>-->
						<xsl:for-each select="archdesc/did/unittitle/node()[not(self::unitdate)]">
							<xsl:value-of select="."/>
						</xsl:for-each>
					</title>
				</head>

				<body data-spy="scroll" data-target=".nav" data-offset="50">
					<div id="wrapper">

					<!-- Schema.org metadata -->
						<div itemscope="" typeof="http:/schema.org/CollectionPage">
							<xsl:if test="/ead/xtf:meta/description">
								<meta itemprop="http:/schema.org/description">
									<xsl:attribute name="content">
										<xsl:value-of select="/ead/xtf:meta/description"/>
									</xsl:attribute>
								</meta>
							</xsl:if>
							<meta itemprop="http:/schema.org/name">
								<xsl:attribute name="content">
									<xsl:value-of select="/ead/xtf:meta/title"/>
								</xsl:attribute>
							</meta>
							<!-- may be able to improve this based on JB work on repository -->
							<div itemprop="http:/schema.org/contentLocation" itemscope=""
								itemtype="http:/schema.org/Place">
								<meta itemprop="http:/schema.org/name">
									<xsl:attribute name="content">
										<xsl:value-of select="/ead/xtf:meta/publisher"/>
									</xsl:attribute>
								</meta>
							</div>
							<xsl:for-each select="/ead/xtf:meta/contributor">
								<meta itemprop="http:/schema.org/contributor">
									<xsl:attribute name="content">
										<xsl:apply-templates/>
									</xsl:attribute>
								</meta>
							</xsl:for-each>
							<xsl:for-each select="/ead/xtf:meta/creator">
								<xsl:if test="/ead/xtf:meta/creator != 'unknown'">
									<meta itemprop="http:/schema.org/creator">
										<xsl:attribute name="content">
											<xsl:apply-templates/>
										</xsl:attribute>
									</meta>
								</xsl:if>
							</xsl:for-each>
							<div itemprop="http:/schema.org/dateCreated" itemscope="" itemtype="Date">
								<meta itemprop="date">
									<xsl:attribute name="content">
										<xsl:value-of select="/ead/xtf:meta/date"/>
									</xsl:attribute>
								</meta>
							</div>
							<meta itemprop="http:/schema.org/inLanguage" content="en"/>
							<!-- may be able to improve this based on JB work on repository -->
							<div itemprop="http:/schema.org/publisher" itemscope=""
								itemtype="http:/schema.org/organization">
								<meta itemprop="http:/schema.org/name">
									<xsl:attribute name="content">
										<xsl:value-of select="/ead/xtf:meta/publisher"/>
									</xsl:attribute>
								</meta>
							</div>
						</div>
						<!-- End Schema.org metadata -->

						<xsl:call-template name="bbar"/>
						<div id="page-content-wrapper">
						
						
							<div class="container-fluid">
								
								<!--<div class="row" id="topSpacer"></div>-->
								
								<!--Breadcrumbs-->
								<!--<ol class="breadcrumb">
									<li><a href="http://lwww.albany.edu">UAlbany</a></li>
									<li><a href="http://library.albany.edu">University Libraries</a></li>
									<li><a href="http://library.albany.edu/archive/">M.E. Grenander Special Collections &amp; Archives</a></li>
									<li class="active"><xsl:value-of select="substring-before(eadheader/filedesc/titlestmt/titleproper, '(')"/></li>
								</ol>-->
								
								<div class="row" id="collectionPage">
									<!--<div class="col-sm-3 col-md-2 sidebar">
										<xsl:call-template name="toc"/>
									</div>-->
									<div class="col-lg-12" id="collectionTitle">
										<div class="row section">
											<xsl:apply-templates select="eadheader"/>
											<a href="#menu-toggle" class="btn btn-default" id="menu-toggle"><i class="glyphicon glyphicon-menu-hamburger"></i></a>
											<xsl:apply-templates select="archdesc/did"/>
										</div>
									</div>
								</div>
								<xsl:call-template name="body"/>
								<!--<div class="row section">
									<div class="wallOText">
										<div class="page-header">
										  <h1>Example Page Header</h1>
										</div>
										
									</div>
								</div>
								<div class="row">
									<div class="col-lg-12">
										<xsl:call-template name="body"/>
									</div>
								</div>-->
							</div>
						</div>
					</div>
				</body>

				<!--<frameset rows="120,*">
               <frame frameborder="1" scrolling="no" title="Navigation Bar">
                  <xsl:attribute name="name">bbar</xsl:attribute>
                  <xsl:attribute name="src"><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$bbar.href"/></xsl:attribute>
               </frame>
               <frameset cols="35%,65%">
                  <frame frameborder="1" title="Table of Contents">
                     <xsl:attribute name="name">toc</xsl:attribute>
                     <xsl:attribute name="src"><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$toc.href"/></xsl:attribute>
                  </frame>
                  <frame frameborder="1" title="Content">
                     <xsl:attribute name="name">content</xsl:attribute>
                     <xsl:attribute name="src"><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>#X</xsl:attribute>
                  </frame>
               </frameset>
               <noframes>
                  <body>
                     <h1>Sorry, your browser doesn't support frames...</h1>
                  </body>
               </noframes>
            </frameset>-->
			</html>
		</xsl:result-document>
	</xsl:template>

	<!-- ====================================================================== -->
	<!-- TOC Templates                                                          -->
	<!-- ====================================================================== -->

	<xsl:template name="toc">
		<xsl:param name="aboutNodes"/>
		<xsl:param name="historyNodes"/>
		<xsl:param name="accessNodes"/>
		<xsl:variable name="sum">
			<xsl:choose>
				<xsl:when test="($query != '0') and ($query != '')">
					<xsl:value-of select="number(/*[1]/@xtf:hitCount)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="occur">
			<xsl:choose>
				<xsl:when test="$sum != 1">occurrences</xsl:when>
				<xsl:otherwise>occurrence</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="aboutHit.count" select="sum($aboutNodes/@xtf:hitCount)"/>
		<xsl:variable name="historyHit.count" select="sum($historyNodes/@xtf:hitCount)"/>
		<xsl:variable name="accessHit.count" select="sum($accessNodes/@xtf:hitCount)"/>

		<xsl:call-template name="translate">
			<xsl:with-param name="resultTree">		
				<div class="leftNavbar">
				
					<!-- fixed left side navbar for large screens-->
					<div class="nav navbar-nav side-nav">
					
						<!-- Draft fixed menu and search on top of left column
						<div id="menuPanel" class="panel panel-default">
						  <div class="panel-heading">
						  
								<form id="searchForm2" class="navbar-form" role="search" action="search">
									<div class="input-group">
										<div class="input-group-btn">
											<div class="dropdown">
											  <button id="menuBtn" class="btn btn-default dropdown-toggle"  type="button"  data-toggle="dropdown">
											  <img class="dropdownLogo" src="icons/ua/mainLogo.png" />
											  <xsl:text> </xsl:text>
											  <span class="caret"></span></button>
											  <ul class="dropdown-menu">
												<li>
													<a href="search">Collections</a>
													<a class="trigger right-caret">Collections</a>
													<ul class="dropdown-menu sub-menu">
														<li><a href="search">About Collections</a></li>
														<li><a href="http://library.albany.edu/archive/apap">NY Modern Political Archive</a></li>
														<li><a href="http://library.albany.edu/archive/ndpa">National Death Penalty Archive</a></li>
														<li><a href="http://library.albany.edu/archive/ger">German Intellectual Émigré Papers</a></li>
														<li><a href="http://library.albany.edu/archive/ua">University Archives</a></li>
														<li><a href="http://library.albany.edu/archive/mathes">Mathes Childrens Literature</a></li>
														<li><a href="http://library.albany.edu/archive/manuscript">Rare Books and Manuscripts</a></li>
														<li><a href="http://library.albany.edu/archive/collections/alpha">A-Z Complete List of Collections</a></li>
														<li><a href="http://library.albany.edu/archive/collections/subject">Subject Guides to Collections</a></li>
													</ul>
												</li>
												<li><a href="http://library.albany.edu/archive/digitalcollections">Digital Selections</a></li>
												<li><a href="http://library.albany.edu/archive/exhibits">Exhibits</a></li>
												<li><a href="http://library.albany.edu/archive/universityarchives">University Records</a></li>
												<li><a href="http://library.albany.edu/archive/about">About</a></li>
												<li><a href="http://library.albany.edu/archive/contact">Contact</a></li>
											  </ul>
											</div>
										</div>
										
										<input id="searchAll2" type="text" class="form-control" placeholder="Search" name="keyword" value=""/>
										<input type="text" class="form-control" placeholder="Search this Collection" name="query" id="srch-term2" disabled="disabled"/>
										<input id="srch-termValue2" type="hidden" name="docId" value="{$docId}" disabled="disabled"/>

										
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
						</div>-->
						
						<xsl:if test="($query != '0') and ($query != '')">
							<div class="alert alert-info alert-dismissable">
								<div class="text-center">
									<b>
										<span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
										<xsl:text> </xsl:text>
										<span class="sr-only">Information:</span>
										<span class="hit-count">
											<xsl:value-of select="$sum"/>
										</span>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$occur"/>
										<xsl:text> of </xsl:text>
										<xsl:text>"</xsl:text>
										<span class="hit-count">
											<xsl:value-of select="$query"/>
										</span>
										<xsl:text>"</xsl:text>
									</b>
									<xsl:text> [</xsl:text>
									<a class="clearHits"><xsl:attribute name="href">
											<xsl:value-of select="$doc.path"/>
										</xsl:attribute>
										<xsl:text>Clear Hits</xsl:text>
									</a>
									<xsl:text>]</xsl:text>
								</div>
							</div>
						</xsl:if>
						
						
						
						<div id="collectionMenu">
							<div id="panel1" class="panel panel-default">
								  <div class="panel-heading">
									<h5 class="panel-title">
										<a href="#">
											<!--<xsl:value-of select="archdesc/did/unittitle/text()"/>-->
											<xsl:apply-templates select="archdesc/did/unittitle/node()[not(self::unitdate)]" />
										</a>
									</h5>
								  </div>
						
								<div id="aboutMenu" class="list-group panel">
									<a href="#about" class="list-group-item" data-toggle="collapse" data-parent="#panel1">About the Collection <span class="glyphicon glyphicon-triangle-bottom"></span>
										<xsl:if test="$aboutHit.count &gt; 0">
											<span class="badge">
												<xsl:value-of select="$aboutHit.count"/>
											</span>
										</xsl:if>
									</a>
									<div class="collapse" id="about">
										<a href="#abstract" class="list-group-item">Abstract and Summary</a>
										<xsl:if test="archdesc/bioghist">
											<xsl:apply-templates select="archdesc/bioghist" mode="tocLink-bioghist"/>
										</xsl:if>
										<xsl:if test="archdesc/scopecontent">
											<xsl:apply-templates select="archdesc/scopecontent" mode="tocLink-scope"/>
										</xsl:if>
										<xsl:if test="archdesc/phystech">
											<xsl:apply-templates select="archdesc/phystech" mode="tocLink-phystech"/>
										</xsl:if>
										<xsl:if test="archdesc/arrangement">
											<xsl:apply-templates select="archdesc/arrangement" mode="tocLink-arrange"/>
										</xsl:if>
										<xsl:if test="archdesc/did/langmaterial">
											<xsl:apply-templates select="archdesc/did/langmaterial" mode="tocLink-lang"/>
										</xsl:if>
										<xsl:if test="archdesc/relatedmaterial">
											<xsl:apply-templates select="archdesc/relatedmaterial" mode="tocLink-relatedmaterial"/>
										</xsl:if>
										<xsl:if test="archdesc/separatedmaterial">
											<xsl:apply-templates select="archdesc/separatedmaterial" mode="tocLink-separatedmaterial"/>
										</xsl:if>
										<xsl:if test="archdesc/odd">
											<xsl:apply-templates select="archdesc/odd" mode="tocLink-odd"/>
										</xsl:if>
									</div>
									<a href="#collectionHistory" class="list-group-item" data-toggle="collapse" data-parent="#panel1">Collection History <span class="glyphicon glyphicon-triangle-bottom"></span>
										<xsl:if test="$historyHit.count &gt; 0">
											<span class="badge">
												<xsl:value-of select="$historyHit.count"/>
											</span>
										</xsl:if>
									</a>
									<div class="collapse" id="collectionHistory">
										<xsl:if test="archdesc/appraisal">
											<xsl:apply-templates select="archdesc/appraisal" mode="tocLink-appraisal"/>
										</xsl:if>
										<xsl:if test="archdesc/acqinfo">
											<xsl:apply-templates select="archdesc/acqinfo" mode="tocLink-acqinfo"/>
										</xsl:if>
										<xsl:if test="archdesc/custodhist">
											<xsl:apply-templates select="archdesc/custodhist" mode="tocLink-custodhist"/>
										</xsl:if>
										<xsl:if test="eadheader/filedesc/titlestmt/author">
											<xsl:apply-templates select="eadheader/filedesc/titlestmt/author" mode="tocLink-author"/>
										</xsl:if>
										<xsl:if test="archdesc/altformavail">
											<xsl:apply-templates select="archdesc/altformavail" mode="tocLink-altformavail"/>
										</xsl:if>
										<xsl:if test="archdesc/accruals">
											<xsl:apply-templates select="archdesc/accruals" mode="tocLink-accruals"/>
										</xsl:if>
										<xsl:if test="eadheader/profiledesc/creation">
											<xsl:apply-templates select="eadheader/profiledesc/creation" mode="tocLink-publication"/>
										</xsl:if>
										<xsl:if test="eadheader/revisiondesc/change/item/text()">
											<xsl:apply-templates select="eadheader/revisiondesc" mode="tocLink-revisiondesc"/>
										</xsl:if>
									</div>
									<a href="#accessUse" class="list-group-item" data-toggle="collapse" data-parent="#panel1">Access and Use <span class="glyphicon glyphicon-triangle-bottom"></span>
										<xsl:if test="$accessHit.count &gt; 0">
											<span class="badge">
												<xsl:value-of select="$accessHit.count"/>
												<xsl:value-of select="$accessHit.count"/>
											</span>
										</xsl:if>
									</a>
									<div class="collapse" id="accessUse">
										<a href="#howto" class="list-group-item">How to Access Materials</a>
										<xsl:if test="archdesc/accessrestrict">
											<xsl:apply-templates select="archdesc/accessrestrict" mode="tocLink-access"/>
										</xsl:if>
										<xsl:if test="archdesc/userestrict">
											<xsl:apply-templates select="archdesc/userestrict" mode="tocLink-use"/>
										</xsl:if>
										<xsl:if test="archdesc/prefercite">
											<xsl:apply-templates select="archdesc/prefercite" mode="tocLink-citation"/>
										</xsl:if>
									</div>
								</div>
							</div>
							
							<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request"><i class="glyphicon glyphicon-folder-close"/> Request</button>
							
							<!--Container List-->
							<xsl:if test="archdesc/dsc">
								<xsl:choose>
									<xsl:when test="archdesc/dsc/c01[@level='series']">
										<div id="panel2" class="panel panel-default">
											  <div class="panel-heading">
												<h5 class="panel-title">Contents</h5>
											  </div>
												<div id="seriesMenu" class="list-group panel">
													<xsl:for-each select="archdesc/dsc/c01[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection'] | archdesc/dsc/c[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection']">
														<xsl:choose>
															<xsl:when test="c02[@level='subseries']">
																<xsl:apply-templates select="." mode="tocLink-children"/>
																<div class="collapse">
																	<xsl:attribute name="id">
																		<xsl:value-of select="translate(@id, '.', '--')"/>
																	</xsl:attribute>
																	<xsl:for-each select="c02[@level='subseries']">
																		<xsl:choose>
																			<xsl:when test="c03[@level='subseries']">
																				<a id="tocItem" href="#"  class="list-group-item sub-button" role="button">
																					<xsl:attribute name="href">
																						<xsl:text>#</xsl:text>
																						<xsl:value-of select="translate(@id, '.', '--')"/>
																					</xsl:attribute>
																					<xsl:value-of select="did/unittitle"/>
																					<xsl:text> </xsl:text>
																					<i class="glyphicon glyphicon-triangle-bottom"></i>
																				</a>
																				<ul class="sub-menu">
																					<xsl:for-each select="c03[@level='subseries']">
																						<a class="list-group-item">
																							<xsl:attribute name="href">
																								<xsl:text>#</xsl:text>
																								<xsl:value-of select="translate(@id, '.', '--')"/>
																							</xsl:attribute>
																							<xsl:value-of select="did/unittitle"/>
																						</a>
																					</xsl:for-each>
																				</ul>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:apply-templates select="." mode="tocLink"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:for-each>
																</div>
															</xsl:when>
															<xsl:otherwise>
																<xsl:apply-templates select="." mode="tocLink"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:for-each>
												</div>
											</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="list-group panel">
													<xsl:apply-templates select="archdesc/dsc" mode="tocLink-contents"/>
												</div>
											</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							
						</div>
					</div>
						
						<!-- Left side navbar for small devices -->
						<div id="sidebar-wrapper">
					
											
						<ul class="nav navbar-nav" id="panel3">
							<li id="fa-brand">
								<a href="#">
									<!--<xsl:value-of select="archdesc/did/unittitle/text()"/>-->
									<xsl:apply-templates select="archdesc/did/unittitle/node()[not(self::unitdate)]" />
								</a>
							</li>
							<xsl:if test="($query != '0') and ($query != '')">
								<div class="alert alert-info alert-dismissable">
									<div class="text-center">
										<b>
											<span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
											<xsl:text> </xsl:text>
											<span class="sr-only">Information:</span>
											<span class="hit-count">
												<xsl:value-of select="$sum"/>
											</span>
											<xsl:text> </xsl:text>
											<xsl:value-of select="$occur"/>
											<xsl:text> of </xsl:text>
											<xsl:text>"</xsl:text>
											<span class="hit-count">
												<xsl:value-of select="$query"/>
											</span>
											<xsl:text>"</xsl:text>
										</b>
										<xsl:text> [</xsl:text>
										<a class="clearHits"><xsl:attribute name="href">
												<xsl:value-of select="$doc.path"/>
											</xsl:attribute>
											<xsl:text>Clear Hits</xsl:text>
										</a>
										<xsl:text>]</xsl:text>
									</div>
								</div>
							</xsl:if>
							<li class="dropdown">
								<a href="#"  class="dropdown-toggle" data-toggle="dropdown" role="button">About the Collection <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<a href="#abstract" class="list-group-item">Abstract and Summary</a>
									<xsl:if test="archdesc/bioghist">
										<xsl:apply-templates select="archdesc/bioghist" mode="tocLink-bioghist"/>
									</xsl:if>
									<xsl:if test="archdesc/scopecontent">
										<xsl:apply-templates select="archdesc/scopecontent" mode="tocLink-scope"/>
									</xsl:if>
									<xsl:if test="archdesc/phystech">
										<xsl:apply-templates select="archdesc/phystech" mode="tocLink-phystech"/>
									</xsl:if>
									<xsl:if test="archdesc/arrangement">
										<xsl:apply-templates select="archdesc/arrangement" mode="tocLink-arrange"/>
									</xsl:if>
									<xsl:if test="archdesc/did/langmaterial">
										<xsl:apply-templates select="archdesc/did/langmaterial" mode="tocLink-lang"/>
									</xsl:if>
									<xsl:if test="archdesc/relatedmaterial">
										<xsl:apply-templates select="archdesc/relatedmaterial" mode="tocLink-relatedmaterial"/>
									</xsl:if>
									<xsl:if test="archdesc/separatedmaterial">
										<xsl:apply-templates select="archdesc/separatedmaterial" mode="tocLink-separatedmaterial"/>
									</xsl:if>
									<xsl:if test="archdesc/odd">
										<xsl:apply-templates select="archdesc/odd" mode="tocLink-odd"/>
									</xsl:if>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#"  class="dropdown-toggle" data-toggle="dropdown" role="button">Collection History <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<xsl:if test="archdesc/appraisal">
											<xsl:apply-templates select="archdesc/appraisal" mode="tocLink-appraisal"/>
										</xsl:if>
										<xsl:if test="archdesc/acqinfo">
											<xsl:apply-templates select="archdesc/acqinfo" mode="tocLink-acqinfo"/>
										</xsl:if>
										<xsl:if test="archdesc/custodhist">
											<xsl:apply-templates select="archdesc/custodhist" mode="tocLink-custodhist"/>
										</xsl:if>
										<xsl:if test="eadheader/filedesc/titlestmt/author">
											<xsl:apply-templates select="eadheader/filedesc/titlestmt/author" mode="tocLink-author"/>
										</xsl:if>
										<xsl:if test="archdesc/altformavail">
											<xsl:apply-templates select="archdesc/altformavail" mode="tocLink-altformavail"/>
										</xsl:if>
										<xsl:if test="archdesc/accruals">
											<xsl:apply-templates select="archdesc/accruals" mode="tocLink-accruals"/>
										</xsl:if>
										<xsl:if test="eadheader/profiledesc/creation">
											<xsl:apply-templates select="eadheader/profiledesc/creation" mode="tocLink-publication"/>
										</xsl:if>
										<xsl:if test="eadheader/revisiondesc/change/item/text()">
											<xsl:apply-templates select="eadheader/revisiondesc" mode="tocLink-revisiondesc"/>
										</xsl:if>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#"  class="dropdown-toggle" data-toggle="dropdown" role="button">Access and Use <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<a href="#howto" class="list-group-item">How to Access Materials</a>
										<xsl:if test="archdesc/accessrestrict">
											<xsl:apply-templates select="archdesc/accessrestrict" mode="tocLink-access"/>
										</xsl:if>
										<xsl:if test="archdesc/userestrict">
											<xsl:apply-templates select="archdesc/userestrict" mode="tocLink-use"/>
										</xsl:if>
										<xsl:if test="archdesc/prefercite">
											<xsl:apply-templates select="archdesc/prefercite" mode="tocLink-citation"/>
										</xsl:if>
								</ul>
							</li>
						</ul>
						
						<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request"><i class="glyphicon glyphicon-folder-close"/> Request</button>
													
						<!--Container List-->
						<xsl:if test="archdesc/dsc">
							<xsl:choose>
								<xsl:when test="archdesc/dsc/c01[@level='series']">
									<ul id="panel4" class="nav navbar-nav">
										  <li id="contents-brand">
											<a>Contents</a>
										  </li>
											<xsl:for-each select="archdesc/dsc/c01[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection'] | archdesc/dsc/c[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection']">
												<xsl:choose>
													<xsl:when test="c02[@level='subseries']">
														<li class="dropdown">
															<a href="#"  class="dropdown-toggle" data-toggle="dropdown" role="button">
																<xsl:value-of select="did/unittitle"/>
																<span class="caret"></span>
															</a>
															<ul class="dropdown-menu">
																<xsl:for-each select="c02[@level='subseries']">
																	<!--<xsl:choose>
																		<xsl:when test="c03[@level='subseries']">
																			<a class="list-group-item sub-button" role="button">
																				<xsl:attribute name="href">
																					<xsl:text>#</xsl:text>
																					<xsl:value-of select="@id"/>
																				</xsl:attribute>
																				<xsl:value-of select="did/unittitle"/>
																				<xsl:text> </xsl:text>
																				<i class="glyphicon glyphicon-triangle-bottom"></i>
																			</a>
																			<ul class="sub-menu">
																				<xsl:for-each select="c03[@level='subseries']">
																					<a class="list-group-item">
																						<xsl:attribute name="href">
																							<xsl:text>#</xsl:text>
																							<xsl:value-of select="@id"/>
																						</xsl:attribute>
																						<xsl:value-of select="did/unittitle"/>
																					</a>
																				</xsl:for-each>
																			</ul>
																		</xsl:when>
																		<xsl:otherwise>-->
																			<a class="list-group-item">
																				<xsl:attribute name="href">
																					<xsl:text>#</xsl:text>
																					<xsl:value-of select="translate(@id, '.', '--')"/>
																				</xsl:attribute>
																				<xsl:value-of select="did/unittitle"/>
																			</a>
																		<!--</xsl:otherwise>
																	</xsl:choose>-->
																</xsl:for-each>
															</ul>
														</li>
													</xsl:when>
													<xsl:otherwise>
														<li>
															<a role="button">
																<xsl:attribute name="href">
																	<xsl:text>#</xsl:text>
																	<xsl:value-of select="translate(@id, '.', '--')"/>
																</xsl:attribute>
																<xsl:value-of select="did/unittitle"/>
															</a>
														</li>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
									</ul>
								</xsl:when>
								<xsl:otherwise>
									<ul>
										<li>
											<xsl:apply-templates select="archdesc/dsc" mode="tocLink-contents"/>
										</li>
									</ul>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
								

												
						
						<!-- The Table of Contents template performs a series of tests to
							determine which elements will be included in the table
							of contents.  Each if statement tests to see if there is
							a matching element with content in the finding aid.-->
						<!--<xsl:if test="archdesc/did">
							<xsl:call-template name="make-toc-link">
								<xsl:with-param name="name" select="'Descriptive Summary'"/>
								<xsl:with-param name="id" select="'headerlink'"/>
								<xsl:with-param name="nodes" select="archdesc/did"/>
							</xsl:call-template>
						</xsl:if>-->
						
						<!-- old code from NY3Rs
						<xsl:if test="archdesc/did/head">
							<xsl:apply-templates select="archdesc/did/head" mode="tocLink"/>
						</xsl:if>
						<xsl:if test="archdesc/bioghist/head">
							<xsl:apply-templates select="archdesc/bioghist/head" mode="tocLink"/>
						</xsl:if>
						<xsl:if test="archdesc/scopecontent/head">
							<xsl:apply-templates select="archdesc/scopecontent/head" mode="tocLink"
							/>
						</xsl:if>
						<xsl:if test="archdesc/arrangement/head">
							<xsl:apply-templates select="archdesc/arrangement/head" mode="tocLink"/>
						</xsl:if>

						<xsl:if
							test="archdesc/userestrict/head   or archdesc/accessrestrict/head   or archdesc/*/userestrict/head   or archdesc/*/accessrestrict/head">
							<xsl:call-template name="make-toc-link">
								<xsl:with-param name="name" select="'Restrictions'"/>
								<xsl:with-param name="id" select="'restrictlink'"/>
								<xsl:with-param name="nodes"
									select="archdesc/userestrict|archdesc/accessrestrict|archdesc/*/userestrict|archdesc/*/accessrestrict"
								/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="archdesc/controlaccess/head">
							<xsl:apply-templates select="archdesc/controlaccess/head" mode="tocLink"
							/>
						</xsl:if>
						<xsl:if
							test="archdesc/relatedmaterial   or archdesc/separatedmaterial   or archdesc/*/relatedmaterial   or archdesc/*/separatedmaterial">
							<xsl:call-template name="make-toc-link">
								<xsl:with-param name="name" select="'Related Material'"/>
								<xsl:with-param name="id" select="'relatedmatlink'"/>
								<xsl:with-param name="nodes"
									select="archdesc/relatedmaterial|archdesc/separatedmaterial|archdesc/*/relatedmaterial|archdesc/*/separatedmaterial"
								/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="archdesc/acqinfo/*   or archdesc/processinfo/* 
							or archdesc/prefercite/*   or archdesc/custodialhist/*   
							or archdesc/processinfo/*   or archdesc/altformavail/* 
							or archdesc/appraisal/*   or archdesc/accruals/*   
							or archdesc/*/acqinfo/*   or archdesc/*/processinfo/*  
							or archdesc/*/altformavail/* or archdesc/*/prefercite/*   or archdesc/*/custodialhist/*   or archdesc/*/procinfo/*   or archdesc/*/appraisal/*   or archdesc/*/accruals/*">
							<xsl:call-template name="make-toc-link">
								<xsl:with-param name="name" select="'Administrative Information'"/>
								<xsl:with-param name="id" select="'adminlink'"/>
								<xsl:with-param name="nodes"
									select="archdesc/acqinfo|archdesc/prefercite|archdesc/custodialhist|archdesc/custodialhist|archdesc/processinfo|archdesc/altformavail|archdesc/appraisal|archdesc/accruals|archdesc/*/acqinfo|archdesc/*/processinfo|archdesc/*/altformavail|archdesc/*/prefercite|archdesc/*/custodialhist|archdesc/*/procinfo|archdesc/*/appraisal|archdesc/*/accruals/*"
								/>
							</xsl:call-template>
						</xsl:if>

						<xsl:if test="archdesc/otherfindaid/head    or archdesc/*/otherfindaid/head">
							<xsl:choose>
								<xsl:when test="archdesc/otherfindaid/head">
									<xsl:apply-templates select="archdesc/otherfindaid/head"
										mode="tocLink"/>
								</xsl:when>
								<xsl:when test="archdesc/*/otherfindaid/head">
									<xsl:apply-templates select="archdesc/*/otherfindaid/head"
										mode="tocLink"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>

						
						<xsl:for-each select="archdesc/odd">
							<xsl:call-template name="make-toc-link">
								<xsl:with-param name="name" select="head"/>
								<xsl:with-param name="id" select="@id"/>
								<xsl:with-param name="nodes" select="."/>
							</xsl:call-template>
						</xsl:for-each>

						<xsl:if test="archdesc/bibliography/head    or archdesc/*/bibliography/head">
							<xsl:choose>
								<xsl:when test="archdesc/bibliography/head">
									<xsl:apply-templates select="archdesc/bibliography/head"
										mode="tocLink"/>
								</xsl:when>
								<xsl:when test="archdesc/*/bibliography/head">
									<xsl:apply-templates select="archdesc/*/bibliography/head"
										mode="tocLink"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="archdesc/index/head    or archdesc/*/index/head">
							<xsl:choose>
								<xsl:when test="archdesc/index/head">
									<xsl:apply-templates select="archdesc/index/head" mode="tocLink"
									/>
								</xsl:when>
								<xsl:when test="archdesc/*/index/head">
									<xsl:apply-templates select="archdesc/*/index/head"
										mode="tocLink"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="archdesc/dsc/head">
							<li role="separator" class="divider"></li>
							<xsl:apply-templates select="archdesc/dsc/head" mode="tocLink"/>
							 Displays the unittitle and unitdates for a c01 if it is a series (as
								evidenced by the level attribute series)and numbers them
								to form a hyperlink to each.   Delete this section if you do not
								wish the c01 titles to appear in the table of contents.
							

							<xsl:for-each
								select="archdesc/dsc/c01[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection']
								| archdesc/dsc/c[@level='series' or @level='subseries' or @level='subgrp' or @level='subcollection']">
								 <xsl:choose>
									 <xsl:when test="c02[@level='subseries']">
										<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
											<xsl:call-template name="make-toc-link">
												<xsl:with-param name="name">
													<xsl:choose>
														<xsl:when test="did/unittitle/unitdate">
														<xsl:for-each select="did/unittitle">
															<xsl:value-of select="text()"/>
															<xsl:text> </xsl:text>
															<xsl:apply-templates select="./unitdate"/>
														</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
														<xsl:apply-templates select="did/unittitle"/>
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="did/unitdate"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="id" select="@id"/>
												<xsl:with-param name="nodes" select="."/>
												<xsl:with-param name="indent" select="2"/>
											</xsl:call-template>
											<span class="glyphicon glyphicon-triangle-bottom"></span>
											
											<xsl:for-each select="c02[@level='subseries'] | c[@level='subseries']">
												<li>
													<xsl:call-template name="make-toc-link">
														<xsl:with-param name="name">
														<xsl:choose>
														<xsl:when test="did/unittitle/unitdate">
														<xsl:for-each select="did/unittitle">
														<xsl:value-of select="text()"/>
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="./unitdate"/>
														</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
														<xsl:apply-templates select="did/unittitle"/>
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="did/unitdate"/>
														</xsl:otherwise>
														</xsl:choose>
														</xsl:with-param>
														<xsl:with-param name="id" select="@id"/>
														<xsl:with-param name="nodes" select="."/>
														<xsl:with-param name="indent" select="3"/>
													</xsl:call-template>
												</li>
											</xsl:for-each>
											
										</a>
										</xsl:when>
									
										<xsl:otherwise>
											<li>
												<xsl:call-template name="make-toc-link">
													<xsl:with-param name="name">
														<xsl:choose>
															<xsl:when test="did/unittitle/unitdate">
															<xsl:for-each select="did/unittitle">
																<xsl:value-of select="text()"/>
																<xsl:text> </xsl:text>
																<xsl:apply-templates select="./unitdate"/>
															</xsl:for-each>
															</xsl:when>
															<xsl:otherwise>
															<xsl:apply-templates select="did/unittitle"/>
															<xsl:text> </xsl:text>
															<xsl:apply-templates select="did/unitdate"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="id" select="@id"/>
													<xsl:with-param name="nodes" select="."/>
													<xsl:with-param name="indent" select="2"/>
												</xsl:call-template>
											</li>
										</xsl:otherwise>
								
								
									</xsl:choose>

									
							</xsl:for-each>

							
						</xsl:if>
						-->
						
						<!--End of the table of contents. -->
					</div>

				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node()" mode="tocLink-bioghist">
		<xsl:call-template name="make-toc-link-bioghist">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-scope">
		<xsl:call-template name="make-toc-link-scope">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-phystech">
		<xsl:call-template name="make-toc-link-phystech">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-arrange">
		<xsl:call-template name="make-toc-link-arrange">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-lang">
		<xsl:call-template name="make-toc-link-lang">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-separatedmaterial">
		<xsl:call-template name="make-toc-link-separatedmaterial">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-relatedmaterial">
		<xsl:call-template name="make-toc-link-relatedmaterial">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-odd">
		<xsl:call-template name="make-toc-link-odd">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-appraisal">
		<xsl:call-template name="make-toc-link-appraisal">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-acqinfo">
		<xsl:call-template name="make-toc-link-acqinfo">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-custodhist">
		<xsl:call-template name="make-toc-link-custodhist">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-altformavail">
		<xsl:call-template name="make-toc-link-altformavail">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-author">
		<xsl:call-template name="make-toc-link-author">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-accruals">
		<xsl:call-template name="make-toc-link-accruals">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-publication">
		<xsl:call-template name="make-toc-link-publication">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-revisiondesc">
		<xsl:call-template name="make-toc-link-revisiondesc">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-access">
		<xsl:call-template name="make-toc-link-access">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-use">
		<xsl:call-template name="make-toc-link-use">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-citation">
		<xsl:call-template name="make-toc-link-citation">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-contents">
		<xsl:call-template name="make-toc-link-contents">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink">
		<xsl:call-template name="make-toc-link">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="node()" mode="tocLink-children">
		<xsl:call-template name="make-toc-link-children">
			<xsl:with-param name="name" select="string(.)"/>
			<xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
			<xsl:with-param name="nodes" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="make-toc-link-bioghist">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#bioghist" class="list-group-item">
			<xsl:choose>
				<xsl:when test="head">
					<xsl:value-of select="head"/>
				</xsl:when>
				<xsl:otherwise>Historical Note</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-scope">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#scopecontent" class="list-group-item">
			Description of Contents
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-arrange">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#arrangement" class="list-group-item">
			Arrangement
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-lang">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#langmaterial" class="list-group-item">
			Languages
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-separatedmaterial">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#separatedmaterial" class="list-group-item">
			Separated Material
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-relatedmaterial">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#relatedmaterial" class="list-group-item">
			Related Material
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-phystech">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#phystech" class="list-group-item">
			Technical Details
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-odd">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#odd" class="list-group-item">
			More Information
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-appraisal">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#appraisal" class="list-group-item">
			Appraisal Information
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-acqinfo">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#acqinfo" class="list-group-item">
			Acquisition
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-custodhist">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#custodhist" class="list-group-item">
			Custodial History
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-author">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#processinfo" class="list-group-item">
			Processing Details
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-altformavail">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#altformavail" class="list-group-item">
			Alternative Forms
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-accruals">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#accruals" class="list-group-item">
			Accruals
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-publication">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#profiledesc" class="list-group-item">
			Publication
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-revisiondesc">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#revisiondesc" class="list-group-item">
			Revisions
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-access">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#accessrestrict" class="list-group-item">
			Access Restrictions
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-use">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#userestrict" class="list-group-item">
			Use Restrictions
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-citation">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#prefercite" class="list-group-item">
			Citation Example
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-contents">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a href="#containerList" class="list-group-item">
			Contents of Collection
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>

	<xsl:template name="make-toc-link">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>

		<!--actual list template here-->
		<a class="list-group-item" id="tocItem">
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="translate(@id, '.', '--')"/>
			</xsl:attribute>
			<xsl:value-of select="did/unittitle"/>
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="make-toc-link-children">
		<xsl:param name="name"/>
		<xsl:param name="id"/>
		<xsl:param name="nodes"/>
		<xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
		
		<a class="list-group-item" id="tocItem" data-toggle="collapse" data-parent="#panel2">
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="translate(@id, '.', '--')"/>
			</xsl:attribute>
			<xsl:value-of select="did/unittitle"/>
			<xsl:text> </xsl:text>
			<span class="glyphicon glyphicon-triangle-bottom"></span>
			<xsl:if test="$hit.count &gt; 0">
				<span class="badge">
					<xsl:value-of select="$hit.count"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>

	<!-- ====================================================================== -->
	<!-- Print Template                                                         -->
	<!-- ====================================================================== -->

	<xsl:template name="print">
		<html xml:lang="en" lang="en">
			<head>
				<title>
					<xsl:value-of select="$doc.title"/>
				</title>
			</head>
			<body>
				<hr/>
				<div align="center">
					<table width="95%">
						<tr>
							<td>
								<xsl:call-template name="body"/>
							</td>
						</tr>
					</table>
				</div>
				<hr/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
