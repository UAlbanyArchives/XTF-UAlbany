<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Query result formatter stylesheet                                      -->
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
   
   <!-- this stylesheet implements very simple search forms and query results. 
      Alpha and facet browsing are also included. Formatting has been kept to a 
      minimum to make the stylesheets easily adaptable. -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/resultFormatterCommon.xsl"/>
   <xsl:import href="rss.xsl"/>
   <xsl:include href="searchForms.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>
   
   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
   <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/" exclude-result-prefixes="#all">
      <xsl:choose>
         <!-- robot response -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:apply-templates select="crossQueryResult" mode="robot"/>
         </xsl:when>
         <xsl:when test="$smode = 'showBag'">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- book bag -->
         <xsl:when test="$smode = 'addToBag'">
            <span>Added</span>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <!-- no output needed -->
         </xsl:when>
         <xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when>
         <xsl:when test="$smode='getLang'">
            <xsl:call-template name="getLang"/>
         </xsl:when>
         <xsl:when test="$smode='setLang'">
            <xsl:call-template name="setLang"/>
         </xsl:when>
         <!-- rss feed -->
         <xsl:when test="$rmode='rss'">
            <xsl:apply-templates select="crossQueryResult" mode="rss"/>
         </xsl:when>
         <xsl:when test="$smode='emailFolder'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- similar item -->
         <xsl:when test="$smode = 'moreLike'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- modify search -->
         <xsl:when test="contains($smode, '-modify')">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- browse pages -->
         <xsl:when test="$browse-title or $browse-creator">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="browse"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show results -->
         <xsl:when test="crossQueryResult/query/*/*">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="results"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show form -->
         <xsl:otherwise>
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Results Template                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">
      
      <!-- modify query URL -->
      <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'advanced-modify'"/>
      <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>Collections: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/>
            <script src="script/moreless.js" type="text/javascript"/>
			<link rel="stylesheet" href="css/ua/results.css" type="text/css"/>
			<link rel="stylesheet" href="css/font-awesome.min.css"/>
			<link rel="stylesheet" href="css/ua/browseNav.css" type="text/css"></link>
			<link rel="stylesheet" href="css/ua/sideNavbar.css"></link>
			<link rel="stylesheet" href="css/simple-sidebar.css" type="text/css"></link>
           <script src="script/resultsSideNav.js" type="text/javascript"/>
		   <script type="text/javascript" src="js/searchOptions.js"></script>
			<script type="text/javascript" src="http://library.albany.edu/angelfish.js"></script>
			<script type="text/javascript">
				agf.pageview();
			</script>
			<script>
			  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

			  ga('create', 'UA-83180993-1', 'auto');
			  ga('send', 'pageview');

			</script>
			<script>
				$(function () {
				  $('[data-toggle="tooltip"]').tooltip()
				})
			</script>
         </head>
         <body>

               <!-- header -->
               <!--<xsl:copy-of select="$brand.header"/>-->

               <!-- result header -->
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
					<!--<a class="navbar-brand" href="http://library.albany.edu/archiveDev/"><img src="icons/ua/mainLogo.png" height="75px" /></a>-->
					<div class="navbar-brand">
						<a class="logo" href="http://library.albany.edu/archiveDev/"><img src="icons/ua/mainLogo.png" /></a>
						<a class="ualbany" href="http://www.albany.edu"><img src="icons/ua/ualbany.png" /></a>
						<a class="smallLogo" href="http://library.albany.edu/archiveDev/"><img src="icons/ua/mainLogo.png" /></a>
					</div>
				</div>
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav" id="topNavMenu">
						<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Collections <span class="caret"/>
								</a>
								<ul class="dropdown-menu">
									<li>
										<a href="http://meg.library.albany.edu:8080/archive/search">About Collections</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/apap.html">NY State Modern Political Archive</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ndpa.html">National Death Penalty Archive</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ger.html">German Intellectual Émigré</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ua.html">University Archives</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/mathes">Mathes Childrens Literature</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/mss.html">Business and Literary Manuscripts</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/books">Rare Books</a>
									</li>
									<li role="separator" class="divider"></li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/alpha.html">A-Z Complete List of Collections</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/findaids/eresources/static/subjects.html">Subject Guides to Collections</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/historicalresources/">Find Other Historical Repositories</a>
									</li>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Digital Selections <span class="caret"/>
								</a>
								<ul class="dropdown-menu">
									<li><a href="http://library.albany.edu/archiveDev/digitalselections">About Digital Selections</a></li>
									<li><a href="http://luna.albany.edu/luna/servlet">Digital Photograph Collections <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://library.albany.edu/archiveDev/aspSearch">Search Student Newspaper (ASP) Archive</a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/uc9c1q">University Photographs <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/cf080d">United University Professions <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://library.albany.edu/archiveDev/milnedigitalcollections">Milne School</a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/02x34e">WAMC Northeast Public Radio <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/0k7jzo">Marcia Brown <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/n0l6ni">Civil Service Employees Association (CSEA) <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://luna.albany.edu/luna/servlet/s/h6s218">Norman Studer <span class="glyphicon glyphicon-new-window"></span></a></li>
									<li><a href="http://library.albany.edu/speccoll/findaids/apap015.htm#series5">CSEA Newspaper Archive</a></li>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Exhibits <span class="caret"/>
								</a>
								<ul class="dropdown-menu">
									<li>
										<a href="http://library.albany.edu/archiveDev/chronology">Chronological History of UAlbany</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/onthemake">University on the Make, 1960-1970</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/seeger">Remembering Pete Seeger</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/exhibitmilne">The Milne School Murals</a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/campusbuildings/index.htm">Campus Buildings Historical Tour <span class="glyphicon glyphicon-new-window"></span></a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/marciabrown/index.htm">Marcia Brown Exhibit and Resource Website <span class="glyphicon glyphicon-new-window"></span></a>
									</li>
									<li>
										<a href="http://library.albany.edu/speccoll/secretlives/index.htm">The Secret Lives of Toys and Their Friends <span class="glyphicon glyphicon-new-window"></span></a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/exhibits">More...</a>
									</li>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Donors &amp; Records <span class="caret"/>
								</a>
								<ul class="dropdown-menu">
									<li><a href="http://library.albany.edu/archiveDev/outside_donors">Outside Donations of Records</a></li>
									<li><a href="http://library.albany.edu/archiveDev/giving">Giving to the Archives</a></li>
									<li role="separator" class="divider"></li>
									<li><a href="http://library.albany.edu/archiveDev/ua/transferform">Transfer University Records</a></li>
									<li><a href="http://library.albany.edu/archiveDev/universityarchives">University Records FAQ</a></li>
									<li><a href="http://library.albany.edu/archiveDev/ua/recordsCharts">University Records Charts</a></li>
									<!--<li><a href="http://library.albany.edu/archiveDev/ua/recordsLaws">About SUNY Records Laws</a></li>-->
									<li><a href="https://wiki.albany.edu/display/public/askit/Information+Security+Domains%2C+Supporting+Protocols+and+Procedures">About CIO Data Classification System <span class="glyphicon glyphicon-new-window"></span></a></li>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">About <span class="caret"/>
								</a>
								<ul class="dropdown-menu">
									<li>
										<a href="http://library.albany.edu/archiveDev/mission">Mission &amp; Purpose</a>
									</li>
									<li>
										<a href="http://liblogs.albany.edu/grenander/">News</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/visit">Visiting the Archives</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/reference">Make a Request</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/publish_cite">Publishing &amp; Citing</a>
									</li>
									<li>
										<a href="http://library.albany.edu/archiveDev/staff">Staff</a>
									</li>
								</ul>
							</li>
							<li>
								<a href="http://library.albany.edu/archiveDev/reference">Contact</a>
							</li>
					
					<div class="col-sm-3 col-md-3 pull-right" id="searchBox">
								<form class="navbar-form" role="search" action="http://meg.library.albany.edu:8080/archive/search">
									<div class="input-append btn-group">
										<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
											<span class="caret"/>
										</button>
										<ul class="dropdown-menu">
											<li>
												<a id="searchCollections">
													<span class="glyphicon glyphicon-ok"></span> Collections</a>
											</li>
											<li>
												<a id="searchPhotos">
													<span class="glyphicon glyphicon-none"></span> Digital Selections <span class="glyphicon glyphicon-new-window"></span>
												</a>
											</li>
											<li>
												<a id="searchBooks">
													<span class="glyphicon glyphicon-none"></span> Rare Books <span class="glyphicon glyphicon-new-window"></span>
												</a>
											</li>
											<li>
												<a id="searchMathes">
													<span class="glyphicon glyphicon-none"></span> Mathes Children's Literature <span class="glyphicon glyphicon-new-window"></span>
												</a>
											</li>
											<li>
												<a id="searchAsp">
													<span class="glyphicon glyphicon-none"></span> Student Newspaper <span class="glyphicon glyphicon-new-window"></span>
												</a>
											</li>
										</ul>
										<input type="hidden" name="browse-all" value="yes"></input>
										<input id="searchInput" type="text" class="form-control" placeholder="Collections" name="keyword"></input>
										<span class="input-group-addon">
											<button type="submit">
												<span class="glyphicon glyphicon-search"/>
											</button>
										</span>
									</div>
								</form>
							</div>
					</ul>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container -->
		</nav>
		<div id="wrapper" class="row no-gutter">
			<a href="#menu-toggle" class="btn btn-default" id="menu-toggle"><i class="glyphicon glyphicon-menu-hamburger"></i></a>
		   <div id="browseNav" class="side-nav">
			  <!--<div id="narrowSearch" class="page-header text-center">
				<h3>Narrow Search</h3>
			  </div>-->
			  <xsl:if test="facet[@field='facet-genreform']/group">
				 <xsl:apply-templates select="facet[@field='facet-genreform']"/>
			  </xsl:if>
			  <xsl:if test="facet[@field='facet-subject']/group">
				 <xsl:apply-templates select="facet[@field='facet-subject']"/>
			  </xsl:if>
			  <xsl:if test="facet[@field='facet-persname']/group">
				 <xsl:apply-templates select="facet[@field='facet-persname']"/>
			  </xsl:if>
			  <xsl:if test="facet[@field='facet-corpname']/group">
				 <xsl:apply-templates select="facet[@field='facet-corpname']"/>
			  </xsl:if>
			  <xsl:if test="facet[@field='facet-geogname']/group">
				 <xsl:apply-templates select="facet[@field='facet-geogname']"/>
			  </xsl:if>
			  <!-- JB 3/31/2014 add for materials facet
			  <xsl:if test="facet[@field='facet-publisher']/group">
				 <xsl:apply-templates select="facet[@field='facet-publisher']"/>
			  </xsl:if> -->
		   </div>
		   
			<div id="page-content-wrapper">
            <div class="container-fluid">
               
               <!--<xsl:if test="docHit">
                     <div>
                        <xsl:call-template name="pages"/>
                     </div>
                  </xsl:if>-->

               <!-- results -->
               <xsl:choose>
                  <xsl:when test="docHit">
                     <div class="results row">
                        <div class="docHit col-md-12">
                           <!-- search query and results -->
                           <div class="alert alert-warning">
							<div class="resultsLeft">
                              <div>
                              <b><xsl:value-of select="if($browse-all) then 'Browse by' else 'Search'"/>:</b>
                              <xsl:call-template name="format-query"/>
                              <xsl:if test="//spelling">
                                 <xsl:call-template name="did-you-mean">
                                    <xsl:with-param name="baseURL"
                                       select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                                    <xsl:with-param name="spelling" select="//spelling"/>
                                 </xsl:call-template>
                              </xsl:if>
                              </div>
                              <div>
                              <b>Results:</b>&#160; <xsl:variable name="items" select="@totalDocs"/>
                              <xsl:choose>
                                 <xsl:when test="$items = 1">
                                    <span id="itemCount">1</span>
                                    <xsl:text> Item</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <span id="itemCount">
                                       <xsl:value-of select="$items"/>
                                    </span>
                                    <xsl:text> Items</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                              </div>
							  </div>
							  <div class="btn-group options" role="group">
								   <!--<xsl:if test="$smode != 'showBag'">
										 <a type="button" class="btn btn-primary" href="{$xtfURL}{$crossqueryPath}?{$modifyString}"><xsl:text>Modify Search</xsl:text></a>
								   </xsl:if>-->
								   <a type="button" class="btn btn-primary" href="{$xtfURL}{$crossqueryPath}"><xsl:text>New Search</xsl:text></a>
								   <xsl:if test="$smode = 'showBag'">
										<a type="button" class="btn btn-primary" href="{session:getData('queryURL')}"><xsl:text>Return to Search Results</xsl:text></a>
								   </xsl:if>
							  </div>
							  <form method="get" action="{$xtfURL}{$crossqueryPath}" class="resultsSort">
							   <div class="form-group form-inline">
								  <label>Sort by:&#160;</label>
								  <xsl:call-template name="sort.options"/>
								  <xsl:call-template name="hidden.query">
									 <xsl:with-param name="queryString"
										select="editURL:remove($queryString, 'sort')"/>
								  </xsl:call-template>
								  <xsl:text>&#160;</xsl:text>
								  <button class="btn btn-primary" type="submit"><i class="glyphicon glyphicon-arrow-right"></i></button>
							   </div>
							</form>
							<div style="clear: both;height:0px;"></div>
                           </div>
                           
                           <xsl:apply-templates select="docHit"/>
                        </div>
                        <xsl:if test="@totalDocs > $docsPerPage">
                           <div>
                              <xsl:call-template name="pages"/>
                           </div>
                        </xsl:if>
                     </div>
                  </xsl:when>
                  <xsl:otherwise>
                     <div class="results container-fluid">
                        <table class="table">
                           <tr>
                              <td>
                                 <xsl:choose>
                                    <xsl:when test="$smode = 'showBag'">
                                       <p>Your Bookbag is empty.</p>
                                       <p>Click on the 'Add' link next to one or more items in your
                                             <a href="{session:getData('queryURL')}">Search
                                             Results</a>.</p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <p>Sorry, no results...</p>
                                       <p>Try modifying your search:</p>
                                       <div class="forms">
                                          <xsl:choose>
                                             <xsl:when test="matches($smode,'advanced')">
                                                <xsl:call-template name="advancedForm"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:call-template name="simpleForm"/>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </div>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </td>
                           </tr>
                        </table>
                     </div>
                  </xsl:otherwise>
               </xsl:choose>
            </div>
			<div class="container-fluid">
				<footer>
				 <div class="row">
					<div class="footer col-md-12 text-center text-muted">
						<div class="spc-footer">
							<div class="footLeft">
								<p>Open to the public Monday-Friday, 9am-5pm</p>
								<p>Closed for some state holidays and winter intersession</p>
								<p>Located on the top floor of the Science Library on the Uptown Campus</p>
								<p><a href="http://library.albany.edu/archiveDev/directions">Hours and Directions</a></p>
							</div>
							<div class="footRight">
								<p>M. E. Grenander Department of Special Collections &amp; Archives</p>
								<p>Science Library 350</p>
								<p>1400 Washington Avenue</p>
								<p>Albany, NY 12222</p>
							</div>
							<div style="clear: both;"></div>
						</div>
					</div>
				 </div>
			   </footer>
			  </div>
            </div>
			</div>

               
            
         </body>
      </html>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Bookbag Templates                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="getAddress" exclude-result-prefixes="#all">
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Bookbag: Get Address</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="getAddress">
               <h2>E-mail My Bookbag</h2>
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <xsl:text>Address: </xsl:text>
                  <input type="text" name="email"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="reset" value="CLEAR"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="SUBMIT"/>
                  <input type="hidden" name="smode" value="emailFolder"/>
               </form>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">
      
      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
      
      <!-- Change the values for @smtpHost and @from to those valid for your domain -->
      <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail" 
         xsl:extension-element-prefixes="mail" 
         smtpHost="smtp.yourserver.org" 
         useSSL="no" 
         from="admin@yourserver.org"
         to="{$email}" 
         subject="XTF: My Bookbag">
Your XTF Bookbag:
<xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>
      </mail:send>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Citations: Success</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body onload="autoCloseTimer = setTimeout('window.close()', 1000)">
            <xsl:copy-of select="$brand.header"/>
            <h1>E-mail My Citations</h1>
            <b>Your citations have been sent.</b>
         </body>
      </html>
      
   </xsl:template>
   
   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
         <xsl:variable name="path" select="@path"/>
         <xsl:variable name="url">
            <xsl:value-of select="$xtfURL"/>
            <xsl:choose>
               <xsl:when test="matches(meta/display, 'dynaxml')">
                  <xsl:call-template name="dynaxml.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="rawDisplay.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
Item number <xsl:value-of select="$num"/>: 
<xsl:value-of select="meta/creator"/>. <xsl:value-of select="meta/title"/>. <xsl:value-of select="meta/year"/>. 
[<xsl:value-of select="$url"/>]
         
      </xsl:for-each>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">
      
      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>Collections: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/>
         </head>
         <body>
            <div class="container-fluid">
            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- result header -->
            <div class="row">
               <div class="resultsHeader col-md-12">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <div>
                     <a href="{$xtfURL}{$crossqueryPath}?smode=showBag">Bookbag</a> (<span
                        id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>) </div>
                  <div>
                     <b>Browse by:&#160;</b>
                     <xsl:choose>
                        <xsl:when test="$browse-title">Collection</xsl:when>
                        <xsl:when test="$browse-creator">Author</xsl:when>
                        <xsl:otherwise>All Items</xsl:otherwise>
                     </xsl:choose>
                  </div>
                  <div>
                     <a href="{$xtfURL}{$crossqueryPath}">
                        <xsl:text>New Search</xsl:text>
                     </a>
                     <xsl:if test="$smode = 'showBag'">
                        <xsl:text>&#160;|&#160;</xsl:text>
                        <a href="{session:getData('queryURL')}">
                           <xsl:text>Return to Search Results</xsl:text>
                        </a>
                     </xsl:if>
                  </div>
                  <div>
                     <b>Results:&#160;</b>
                     <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                     <xsl:choose>
                        <xsl:when test="$items &gt; 1">
                           <xsl:value-of select="$items"/>
                           <xsl:text> Items</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$items"/>
                           <xsl:text> Item</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </div>
                  <div>
                     <xsl:text>Browse by </xsl:text>
                     <xsl:call-template name="browseLinks"/>
                  </div>
                  <div>
                     <xsl:call-template name="alphaList">
                        <xsl:with-param name="alphaList" select="$alphaList"/>
                     </xsl:call-template>
                  </div>
               </div>
            </div>
            
            <!-- results -->
            <div class="results">
               <table class="table">
                  <tr>
                     <td>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </table>
            </div>
            
            <!-- footer -->
			<div class="container-fluid">
				<footer>
				 <div class="row">
					<div class="footer col-md-12 text-center text-muted">
						<div class="spc-footer">
							<div class="footLeft">
								<p>Open to the public Monday-Friday, 9am-5pm</p>
								<p>Closed for some state holidays and winter intersession</p>
								<p>Located on the top floor of the Science Library on the Uptown Campus</p>
								<p><a href="http://library.albany.edu/archiveDev/directions">Hours and Directions</a></p>
							</div>
							<div class="footRight">
								<p>M. E. Grenander Department of Special Collections &amp; Archives</p>
								<p>Science Library 350</p>
								<p>1400 Washington Avenue</p>
								<p>Albany, NY 12222</p>
							</div>
							<div style="clear: both;"></div>
						</div>
					</div>
				 </div>
			   </footer>
			  </div>
            
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="browseLinks">
      <xsl:choose>
         <xsl:when test="$browse-all">
            <xsl:text>Facet | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Collection</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Author</a>
         </xsl:when>
         <xsl:when test="$browse-title">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | Collection | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Author</a>
         </xsl:when>
         <xsl:when test="$browse-creator">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Collection</a>
            <xsl:text>  | Author</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Collection</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=creator">Author</a>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Document Hit Template                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="docHit" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      
      <div id="main_{@rank}" class="docHit col-md-12">
            <div class="row">
               <div class="col-md-1 col-sm-12">
                  <xsl:choose>
                     <xsl:when test="$sort = ''">
                        <b><xsl:value-of select="@rank"/></b>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </div>
			   <xsl:choose>
					<xsl:when test="snippet">
					   <div class="matchRow row">
						  <div class="col-md-2 col-sm-2 col-xs-6">
							 <b>Matches:&#160;&#160;</b>
							 <br/>
							 <xsl:value-of select="@totalHits"/> 
							 <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
						  </div>
						  <div class="col-md-8  col-sm-12 col-xs-12">
							 <xsl:apply-templates select="snippet" mode="text"/>
						  </div>
					   </div>
					   <div class="col-md-2 col-sm-2 col-xs-6 col-md-offset-1">
						  <xsl:if test="$sort = 'title'">
							 <a name="{$anchor}"/>
						  </xsl:if>
						  <b>Part of Collection:</b>
					   </div>
					</xsl:when>
					<xsl:otherwise>
						<div class="col-md-2 col-sm-2 col-xs-6">
						  <xsl:if test="$sort = 'title'">
							 <a name="{$anchor}"/>
						  </xsl:if>
						  <b>Collection:</b>
					   </div>
					</xsl:otherwise>
				</xsl:choose>
               
               <div class="collectionRow col-md-9  col-sm-12 col-xs-12">
                  <a>
                     <xsl:attribute name="href">
                        <xsl:choose>
                           <xsl:when test="matches(meta/display, 'dynaxml')">
                              <xsl:call-template name="dynaxml.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="rawDisplay.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="meta/title">
                           <xsl:apply-templates select="meta/title[1]"/>
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
                  </a>
                  <!-- HA 3/24/2014 commenting out type icon, since they will all be the same -->
                  <!--<xsl:text>&#160;</xsl:text>
                  <xsl:variable name="type" select="meta/type"/>
                  <span class="typeIcon">
                     <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span>-->
               </div>
               
               <!--<div class="col4 pull-right">
 
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          (YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Delete</a>
                           </span>
                        </xsl:when>
                        <xsl:when test="session:noCookie()">
                           <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                 <span>Added</span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                                 remove add while bookbag is disabled
                                 <span id="add_{@rank}">
                                    <a href="javascript:add_{@rank}()">Add</a>
                                 </span>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </div>--> 
            </div>
			<!-- GW removed creator
            <div class="row">
               <div class="col-md-2 col-md-offset-1">
                  <xsl:if test="$sort = 'creator'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Creator:&#160;&#160;</b>
               </div>
               <div class="col-md-9">
                  <xsl:choose>
                     <xsl:when test="meta/creator">
                        <xsl:apply-templates select="meta/creator[1]"/>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>-->
            <xsl:if test="meta/date != ''">
            <div class="row">
               <div class="col-md-2 col-sm-3 col-xs-3 col-md-offset-1">
                  <b>Date Coverage:</b>
               </div>
               <div class="col-md-9">
                  <xsl:apply-templates select="meta/date"/>
               </div>
            </div>
            </xsl:if>
			<div class="row">
               <div class="col-md-2 col-sm-3 col-xs-3 col-md-offset-1">
                  <xsl:if test="$sort = 'extent'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Extent:</b>
               </div>
               <div class="col-md-9">
                  <xsl:choose>
                     <xsl:when test="meta/extent">
						<xsl:apply-templates select="meta/extent[1]"/>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>
         <!--<xsl:if test="meta/publisher">
            <div class="row">
               <div class="col-md-2 col-md-offset-1">
                  <b>Repository:&#160;&#160;</b>
               </div>
               <div class="col-md-9">
                  <xsl:apply-templates select="meta/publisher[1]"/>
               </div>
            </div>
         </xsl:if>-->
			<xsl:if test="meta/genreform">
               <div class="row">
                  <div class="col-md-2 col-sm-3 col-xs-3 col-md-offset-1">
                     <b>Types:&#160;&#160;</b>
                  </div>
                  <div class="col-md-9">
					<xsl:if test="contains(meta, 'Digital Files')">
						<a>
						<xsl:attribute name="href">
                        <xsl:choose>
                           <xsl:when test="matches(meta/display, 'dynaxml')">
                              <xsl:call-template name="dynaxml.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="rawDisplay.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
						 <xsl:text>#firstDigital</xsl:text>
                     </xsl:attribute>
						Digital Files</a>
						&#160;<span class="digitalFiles glyphicon glyphicon-floppy-disk" data-toggle="tooltip" data-placement="top">
						<xsl:attribute name="title">
						<xsl:choose>
							<xsl:when test="contains(meta/extent[1], 'GB')">
								<xsl:value-of select="substring-after(meta/extent[1], 'GB')"/>
							</xsl:when>
							<xsl:when test="contains(meta/extent[1], 'MB')">
								<xsl:value-of select="substring-after(meta/extent[1], 'MB')"/>
							</xsl:when>
							<xsl:when test="contains(meta/extent[1], 'to date')">
								<xsl:value-of select="substring-after(meta/extent[1], 'to date')"/>
							</xsl:when>
							<xsl:when test="contains(meta/extent[1], 'ft.')">
								<xsl:value-of select="substring-after(meta/extent[1], 'ft.')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="meta/extent[1]"/>
							</xsl:otherwise>
						</xsl:choose>
						</xsl:attribute>
						</span>
					</xsl:if>
					<xsl:if test="contains(meta, 'Web Archives')">
						<a>
						<xsl:attribute name="href">
                        <xsl:choose>
                           <xsl:when test="matches(meta/display, 'dynaxml')">
                              <xsl:call-template name="dynaxml.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="rawDisplay.url">
                                 <xsl:with-param name="path" select="$path"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
						 <xsl:text>#webArch</xsl:text>
                     </xsl:attribute>
						Web Archives</a>&#160;<span class="webArchive fa fa-internet-explorer" data-toggle="tooltip" data-placement="top" title="Contains Web Archives"></span>
					</xsl:if>
                    <!--<xsl:apply-templates select="meta/genreform"/>-->
                  </div>
               </div>
            </xsl:if>
            <xsl:if test="meta/subject">
				<xsl:choose>
				<xsl:when test="snippet"></xsl:when>
				<xsl:otherwise>
					<div class="row">
					  <div class="col-md-2 col-sm-3 col-xs-3 col-md-offset-1">
						 <b>Subjects:&#160;&#160;</b>
					  </div>
					  <div class="col-md-9">
						 <xsl:apply-templates select="meta/subject"/>
					  </div>
				   </div>
				</xsl:otherwise>
				</xsl:choose>
            </xsl:if>
			<xsl:choose>
				<xsl:when test="meta/description">
				   <div class="matchRow row">
					  <div class="col-md-2 col-sm-2 col-xs-6 col-md-offset-1">
						 <b>Abstract:</b>
						 <br/>
					  </div>
					  <div class="col-md-9  col-sm-12 col-xs-12">
						 <xsl:value-of select="meta/description"/>
					  </div>
				   </div>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			
            
            <!-- "more like this" -->
            <!-- HA 3/20/2014 disabling similiar items -->
            <!--<tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td class="col3" colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET', 
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" } 
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr>-->
         <!-- HA Adding extra row for padding, should be removed eventually -->
         <div class="row">&#160;</div>
         <div class="row">&#160;</div>
         
      </div>
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Snippet Template (for snippets in the full text)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
      <xsl:text>...</xsl:text>
      <xsl:apply-templates mode="text"/>
      <xsl:text>...</xsl:text>
      <br/>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in the full text)                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
      <xsl:variable name="path" select="ancestor::docHit/@path"/>
      <xsl:variable name="display" select="ancestor::docHit/meta/display"/>
      <xsl:variable name="hit.rank"><xsl:value-of select="ancestor::snippet/@rank"/></xsl:variable>
      <xsl:variable name="snippet.link">    
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <xsl:value-of select="concat(';#', $hit.rank)"/>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="bg-info hit"><xsl:apply-templates/></span>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$snippet.link}" class="bg-info hit"><xsl:apply-templates/></a>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in meta-data fields)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:otherwise>
            <span class="bg-info hit"><xsl:apply-templates/></span>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- More Like This Template                                                -->
   <!-- ====================================================================== -->
   
   <!-- results -->
   <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="docHit">
            <div class="moreLike">
               <ol>
                  <xsl:apply-templates select="docHit" mode="moreLike"/>
               </ol>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="moreLike">
               <b>No similar documents found.</b>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- docHit -->
   <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      
      <li>
         <xsl:apply-templates select="meta/creator[1]"/>
         <xsl:text>. </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="matches(meta/display, 'dynaxml')">
                     <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="rawDisplay.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="meta/title[1]"/>
         </a>
         <xsl:text>. </xsl:text>
         <xsl:apply-templates select="meta/year[1]"/>
         <xsl:text>. </xsl:text>
      </li>
      
   </xsl:template>
   
</xsl:stylesheet>
