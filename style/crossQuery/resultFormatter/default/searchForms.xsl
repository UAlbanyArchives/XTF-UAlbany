<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0">
   
   
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Search forms stylesheet                                                -->
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
   
   <!-- ====================================================================== -->
   <!-- Global parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:param name="freeformQuery"/>
   
   <!-- ====================================================================== -->
   <!-- Form Templates                                                         -->
   <!-- ====================================================================== -->
   
   <!-- main form page -->
   <xsl:template match="crossQueryResult" mode="form" exclude-result-prefixes="#all">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
         <head>
            <title>About Collections</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
			<script src="script/headerAffix.js" type="text/javascript"></script>
			<link rel="stylesheet" href="css/ua/oneColumn.css" type="text/css"></link>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="searchPage container-fluid">
			<div class="container" id="mainContent">
               <div class="forms">
                     <ul class="nav nav-tabs nav-justified">
                        <li class="{if(matches($smode,'simple')) then 'active' else ''}"><a href="search?smode=simple">Browse</a></li>
                        <li class="{if(matches($smode,'advanced')) then 'active' else ''}"><a href="search?smode=advanced">Advanced Search</a></li>
                        <!-- HA 3/21/2014 goodbye free form query -->
                        <!--<li class="{if(matches($smode,'freeform')) then 'active' else ''}"><a href="search?smode=freeform">Freeform</a></li>-->
                        <li class="{if(matches($smode,'browse')) then 'active' else ''}"><a href="search?browse-all=yes">View All</a></li>
                     </ul>
                  <div class="form">
                     <xsl:choose>
                        <xsl:when test="matches($smode,'simple')">
                           <xsl:call-template name="simpleForm"/>
                        </xsl:when>
                        <xsl:when test="matches($smode,'advanced')">
                           <xsl:call-template name="advancedForm"/>
                        </xsl:when>
                        <xsl:when test="matches($smode,'freeform')">
                           <xsl:call-template name="freeformForm"/>
                        </xsl:when>
                        <!--<xsl:when test="matches($smode,'browse')">
                           <h3>Browse all documents by the available facets, or alphanumerically by
                              author or title:</h3>
                           <div>
                              <xsl:call-template name="browseLinks"/>
                           </div>
                        </xsl:when>-->
                     </xsl:choose>
                  </div>
               </div>
              </div>
			   <xsl:copy-of select="$brand.footer"/>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <!-- simple form -->
   <xsl:template name="simpleForm" exclude-result-prefixes="#all">
    <div id="main-content" class="container">
	<div id="main-content-header">
		<!--<h2 id="page-title">Archive and Manuscript Collections</h2>-->
		<!--<h2 id="page-title">Search Collections</h2>-->
	</div>
	<div id="content">
		<div class="article">
			<!--<p>The M.E. Grenander Department of Special Collections and Archives serves as a repository for manuscripts, archives, books, and special collections of original research materials.</p>-->
			
			<div class="row searchBig">
	<div>
		<ul class="nav nav-tabs">
			<li  class="active">
				<a data-toggle="tab" href="#bigSearchCollections">Collections</a>
			</li>
			<li>
				<a data-toggle="tab" href="#bigSearchSelections">Digital Selections</a>
			</li>
			<li>
				<a data-toggle="tab" href="#bigSearchBooks">Rare Books</a>
			</li>
			<li>
				<a data-toggle="tab" href="#bigSearchMathes">Mathes Collection</a>
			</li>
			<li>
				<a data-toggle="tab" href="#bigSearchNewspapers">Student Newspapers</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="bigSearchCollections" class="tab-pane fade in active">
				<form class="search-form searchBox" role="search" action="http://meg.library.albany.edu:8080/archive/search">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Collections" name="keyword"  value="{$keyword}"/>
						<div class="input-group-btn">
							<button class="btn btn-primary" type="submit">
								<i class="glyphicon glyphicon-search"/>
							</button>
						</div>
					</div>
					<div style="clear: both"/>
				</form>
				<div class="col-xs-12 sequence">
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Labor" role="button">Labor</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Capital+Punishment" role="button">Capital Punishment</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Politics+Politicians" role="button">Politics and Politicians</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?f1-genreform=Web%20Archives" role="button">Web Archives</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Military+Armed+Conflict" role="button">Military and Armed Conflict</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Economics" role="button">Economics</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Africana+Studies" role="button">Africana Studies</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Schenectady" role="button">Schenectady, New York</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?f1-genreform=Digital%20Files" role="button">Digital Files</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Neighborhood+Community+Associations" role="button">Neighborhood and Community Associations</a>
					<a class="btn btn-primary" href="http://meg.library.albany.edu:8080/archive/search?keyword=Education" role="button">Education</a>
				</div>
			</div>
			<div id="bigSearchSelections" class="tab-pane fade">
				<form class="search-form searchBox" role="search" action="http://luna.albany.edu/luna/servlet/view/search">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Digital Selections" name="q" />
						<div class="input-group-btn">
							<button class="btn btn-primary" type="submit">
								<i class="glyphicon glyphicon-search"/>
							</button>
						</div>
					</div>
					<div style="clear: both"/>
				</form>
				<div class="col-xs-12 sequence">
					<a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=construction" role="button">Construction <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=csea" role="button">CSEA <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=marcia+brown" role="button">Marcia Brown <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=pete+seeger" role="button">Pete Seeger <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=wamc" role="button">WAMC <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=university+archives" role="button">University Archives <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=labor+unions" role="button">Labor Unions <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=portraits" role="button">Portraits <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=norman+studer" role="button">Norman Studer <span class="glyphicon glyphicon-new-window"/>
					</a><a class="btn btn-primary" href="http://luna.albany.edu/luna/servlet/view/search?q=Edward+Durell+Stone" role="button">Edward Durell Stone <span class="glyphicon glyphicon-new-window"/>
					</a>
				</div>
			</div>
			<div id="bigSearchBooks" class="tab-pane fade">
				<form class="search-form searchBox" role="search" action="http://p8991-libms1.albany.edu.libproxy.albany.edu/F/">
					<input type='hidden' name='func' value='find-a'/>
					<input type='hidden' name='filter_code_1' value='WLN'/>
					<input type='hidden' name='filter_request_1' value=''/>
					<input type='hidden' name='filter_code_2' value='WYR'/>
					<input type='hidden' name='filter_request_2' value=''/>
					<input type='hidden' name='filter_code_3' value='WYR'/>
					<input type='hidden' name='filter_request_3' value=''/>
					<input type='hidden' name='filter_code_4' value='WCL'/>
					<input type='hidden' name='filter_request_4' value=''/>
					<input type='hidden' name='filter_code_5' value='WSL'/>
					<input type='hidden' name='filter_request_5' value='ALBU'/>
					<input type='hidden' name='find_code' value='WTS'/>
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Rare Books" name="request"/>
						<div class="input-group-btn">
							<button class="btn btn-primary" type="submit">
								<i class="glyphicon glyphicon-search"/>
							</button>
						</div>
					</div>
					<div style="clear: both"/>
				</form>
			</div>
			<div id="bigSearchMathes" class="tab-pane fade">
				<form class="search-form searchBox" role="search" action="http://p8991-libms1.albany.edu.libproxy.albany.edu/F/">
					<input type="hidden" name="func" value="find-a" />
					<input type="hidden" name="filter_code_1" value="WLN" />
					<input type="hidden" name="filter_request_1" value="" />
					<input type="hidden" name="filter_code_2" value="WYR" />
					<input type="hidden" name="filter_request_2" value="" />
					<input type="hidden" name="filter_code_3" value="WYR" />
					<input type="hidden" name="filter_request_3" value="" />
					<input type="hidden" name="filter_code_4" value="WCL" />
					<input type="hidden" name="filter_request_4" value="jc*" />
					<input type="hidden" name="filter_code_5" value="WSL" />
					<input type="hidden" name="filter_request_5" value="ALBU" />
					<input type="hidden" name="find_code" value="WTS" />
					<input type="hidden" name="request_op" value="AND" />
					<input type="hidden" name="find_code" value="WTS" />
					<input type="hidden" name="request" value="" />
					<input type="hidden" name="request_op" value="AND" />
					<input type="hidden" name="find_code" value="WTS" />
					<input type="hidden" name="request" value="" />
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Mathes Collection" name="request" />
						<div class="input-group-btn">
							<button class="btn btn-primary" type="submit">
								<i class="glyphicon glyphicon-search"/>
							</button>
						</div>
					</div>
					<div style="clear: both"></div>
				</form>
			</div>
			<div id="bigSearchNewspapers" class="tab-pane fade">
				<form class="search-form searchBox" role="search" action="http://libsearch.albany.edu/search">
					<input type="hidden" name="site" value="asp_collection" />
					<input type="hidden" name="client" value="asp_frontend" />
					<input type="hidden" name="output" value="xml_no_dtd" />
					<input type="hidden" name="proxystylesheet" value="asp_frontend" />
					<input type="hidden" name="proxyreload" value="1" />
					<input type="hidden" name="numgm" value="5" />
					<input type="hidden" name="filter" value="0" />
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Student Newspapers" name="q" />
						<div class="input-group-btn">
							<button class="btn btn-primary" type="submit">
								<i class="glyphicon glyphicon-search"/>
							</button>
						</div>
					</div>
					<div style="clear: both"/>
				</form>
			</div>
		</div>
	</div>
</div>
			
			<div class="btn-group-wrap">
				<div class="btn-group" role="group" >
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/alpha.html" role="button" type="button" class="btn btn-default">A-Z Complete List</a>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/subjects.html" role="button" type="button" class="btn btn-default">Subject Guides</a>
				</div>
			</div>
			<div class="col-xs-12 sequence">
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/apap.html">New York State Modern Political Archive</a></h4>
							<p>Collections of organizations and individuals active in public policy issues especially since 1950.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ndpa.html">National Death Penalty Archive</a></h4>
							<p>A collection of personal papers and organizational records documenting the United States&#39;s important history of capital punishment.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ger.html">German and Jewish Intellectual Émigré Collection</a></h4>
							<p>Personal and professional papers of German-speaking Émigré in the social sciences, humanities, and the arts and the organizations which assisted those who fled the Nazi regime.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ua.html">University Archives</a></h4>
							<p>Official records of the University at Albany, SUNY, and its predecessor institutions dating to the founding of the New York State Normal School in 1844.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/archiveDev/mathes">Miriam Snow Mathes Historical Children's Literature Collection</a></h4>
							<p>Over 12,000 children's books and periodicals published in the 19th century and up to 1960.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/mss.html">Business, Literary, and Art Collection</a></h4>
							<p>Chiefly New York State and New England business records, state and local history collections, and art and literary manuscripts.</p>
						</div>
					</div>
				</div>
				<div class="well workshop-well">
					<div class="row">
						<div class="col-xs-12">
							<h4><a href="http://library.albany.edu/archiveDev/books">Rare and Specialized Books</a></h4>
							<p>Pre-1801 European and pre-1820 American printed books.</p>
						</div>
					</div>
				</div>
			</div>
			<!--<ul>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/apap.html">New York State Modern Political Archive</a>: Collections of organizations and individuals active in public policy issues especially since 1950.</li>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ger.html">German and Jewish Intellectual Émigré Collection</a>: Personal and professional papers of German-speaking Émigré in the social sciences, humanities, and the arts and the organizations which assisted those who fled the Nazi regime.</li>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ua.html">University Archives</a>: Official records of the University at Albany, SUNY, and its predecessor institutions dating to the founding of the New York State Normal School in 1844. Also includes papers and records related to the faculty and students of the University.</li>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ndpa.html">National Death Penalty Archive</a>: a collection of personal papers and organizational records documenting the United States&#39;s important history of capital punishment.</li>
				<li>
					<a href="http://library.albany.edu/archiveDev/mathes">Miriam Snow Mathes Historical Children's Literature Collection</a>:  includes over 12,000 children's books and periodicals published in the 19th century and up to 1960.</li>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/mss.html">Business, Literary, and Art Collection</a>: Chiefly New York State and New England business records, state and local history collections, and art and literary manuscripts.</li>
				<li>
					<a href="http://library.albany.edu/archiveDev/books">Rare and Specialized Books</a>: Pre-1801 European and pre-1820 American printed books</li>
			</ul>
			<ul>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/alpha.html">Alphabetical Listing of Collections</a>: An alphabetical listing of all manuscript and archival collections.</li>
				<li>
					<a href="http://library.albany.edu/speccoll/findaids/eresources/static/subjects.html">Subject Guides to Collections</a>: Selected subject listings of manuscript and archival collections.</li>
				<li>
					<a href="http://library.albany.edu/archiveDev/chronology">Chronological History of the University at Albany, SUNY</a>: Chronological History of the University at Albany, SUNY, 1844-2008</li>
			</ul>-->
		</div>
	</div>
</div>
   </xsl:template>
   
   <!-- advanced form -->
   <xsl:template name="advancedForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <div class="col-md-6 pull-left">
            <h4>Entire Text</h4>
            <input class="form-control" type="text" name="text" size="30" value="{$text}"/>
            <xsl:choose>
               <xsl:when test="$text-join = 'or'">
                  <input type="radio" name="text-join" value=""/>
                  <xsl:text> all of </xsl:text>
                  <input type="radio" name="text-join" value="or" checked="checked"/>
                  <xsl:text> any of </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <input type="radio" name="text-join" value="" checked="checked"/>
                  <xsl:text> all of </xsl:text>
                  <input type="radio" name="text-join" value="or"/>
                  <xsl:text> any of </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:text>these words</xsl:text>
            <div class="form-group">
            <label>Exclude</label>
               <input class="form-control" type="text" name="text-exclude" value="{$text-exclude}"/>
            </div>
            <div class="form-group">
               <label>Proximity</label>
               <select class="form-control" size="1" name="text-prox">
                  <xsl:choose>
                     <xsl:when test="$text-prox = '1'">
                        <option value=""/>
                        <option value="1" selected="selected">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '2'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2" selected="selected">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '3'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3" selected="selected">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '4'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4" selected="selected">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '5'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5" selected="selected">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '10'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10" selected="selected">10</option>
                        <option value="20">20</option>
                     </xsl:when>
                     <xsl:when test="$text-prox = '20'">
                        <option value=""/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20" selected="selected">20</option>
                     </xsl:when>
                     <xsl:otherwise>
                        <option value="" selected="selected"/>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                     </xsl:otherwise>
                  </xsl:choose>
               </select>
               <xsl:text> word(s)</xsl:text>
            </div>
            <div class="form-group">
               <label>Section</label>
               <xsl:choose>
                  <xsl:when test="$sectionType = 'head'">
                     <input type="radio" name="sectionType" value=""/>
                     <xsl:text> any </xsl:text>
                     <input type="radio" name="sectionType" value="head" checked="checked"/>
                     <xsl:text> headings </xsl:text>
                     <input type="radio" name="sectionType" value="citation"/>
                     <xsl:text> citations </xsl:text>
                  </xsl:when>
                  <xsl:when test="$sectionType = 'note'">
                     <input type="radio" name="sectionType" value=""/>
                     <xsl:text> any </xsl:text>
                     <input type="radio" name="sectionType" value="head"/>
                     <xsl:text> headings </xsl:text>
                     <input type="radio" name="sectionType" value="citation" checked="checked"/>
                     <xsl:text> citations </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <input type="radio" name="sectionType" value="" checked="checked"/>
                     <xsl:text> any </xsl:text>
                     <input type="radio" name="sectionType" value="head"/>
                     <xsl:text> headings </xsl:text>
                     <input type="radio" name="sectionType" value="citation"/>
                     <xsl:text> citations </xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </div>
         </div>
         <div class="col-md-6 pull-right">
            <h4>Metadata</h4>
            <div class="form-group">
               <label>Collection</label>
               <input class="form-control" type="text" name="title" size="20" value="{$title}"/>
            </div>
            <div class="form-group">
               <label>Creator</label>
               <input class="form-control" type="text" name="creator" size="20" value="{$creator}"/>
            </div>
            <div class="form-group">
               <label>Subject</label>
               <input class="form-control" type="text" name="subject" size="20" value="{$subject}"/>
            </div>
            <div class="form-group form-inline">
               <label>Year(s)</label>
               <xsl:text>From </xsl:text>
               <input class="form-control" type="text" name="year" size="4" value="{$year}"/>
               <xsl:text> to </xsl:text>
               <input class="form-control" type="text" name="year-max" size="4" value="{$year-max}"/>
            </div>
            <div class="form-group">
               <label>Type</label>
               <select class="form-control" size="1" name="type">
                  <option value="">All</option>
                  <option value="ead">EAD</option>
                  <option value="html">HTML</option>
                  <option value="word">Word</option>
                  <option value="nlm">NLM</option>
                  <option value="pdf">PDF</option>
                  <option value="tei">TEI</option>
                  <option value="text">Text</option>
               </select>
            </div>
         </div>
         <div class="col-md-12">
            <input type="hidden" name="smode" value="advanced"/>
            <input class="btn btn-primary" type="submit" value="Search"/>
         </div>
         <div class="col-md-12">
            <div id="main-content">
				<div id="main-content-header">
					<h2 id="page-title">Archive and Manuscript Collections</h2>
				</div>
				<div id="content">
					<div class="article">
						<p>The M.E. Grenander Department of Special Collections and Archives serves as a repository for manuscripts, archives, books, and special collections of original research materials.</p>
						<div class="btn-group-wrap">
							<div class="btn-group" role="group" >
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/alpha.html" role="button" type="button" class="btn btn-default">A-Z Complete List</a>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/subjects.html" role="button" type="button" class="btn btn-default">Subject Guides</a>
							</div>
						</div>
						<div class="col-xs-12 sequence">
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/apap.html">New York State Modern Political Archive</a></h4>
										<p>Collections of organizations and individuals active in public policy issues especially since 1950.</p>
									</div>
								</div>
							</div>
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ndpa.html">National Death Penalty Archive</a></h4>
										<p>A collection of personal papers and organizational records documenting the United States&#39;s important history of capital punishment.</p>
									</div>
								</div>
							</div>
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ger.html">German and Jewish Intellectual Émigré Collection</a></h4>
										<p>Personal and professional papers of German-speaking Émigré in the social sciences, humanities, and the arts and the organizations which assisted those who fled the Nazi regime.</p>
									</div>
								</div>
							</div>
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/ua.html">University Archives</a></h4>
										<p>Official records of the University at Albany, SUNY, and its predecessor institutions dating to the founding of the New York State Normal School in 1844.</p>
									</div>
								</div>
							</div>
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/archiveDev/mathes">Miriam Snow Mathes Historical Children's Literature Collection</a></h4>
										<p>Over 12,000 children's books and periodicals published in the 19th century and up to 1960.</p>
									</div>
								</div>
							</div>
							<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/speccoll/findaids/eresources/static/mss.html">Business, Literary, and Art Collection</a></h4>
										<p>Chiefly New York State and New England business records, state and local history collections, and art and literary manuscripts.</p>
									</div>
								</div>
							</div>
							<!--<div class="well workshop-well">
								<div class="row">
									<div class="col-xs-12">
										<h4><a href="http://library.albany.edu/archiveDev/books">Rare and Specialized Books</a></h4>
										<p>Pre-1801 European and pre-1820 American printed books.</p>
									</div>
								</div>
							</div>-->
						</div>
						<!--<ul>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/apap.html">New York State Modern Political Archive</a>: Collections of organizations and individuals active in public policy issues especially since 1950.</li>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ger.html">German and Jewish Intellectual Émigré Collection</a>: Personal and professional papers of German-speaking Émigré in the social sciences, humanities, and the arts and the organizations which assisted those who fled the Nazi regime.</li>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ua.html">University Archives</a>: Official records of the University at Albany, SUNY, and its predecessor institutions dating to the founding of the New York State Normal School in 1844. Also includes papers and records related to the faculty and students of the University.</li>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/ndpa.html">National Death Penalty Archive</a>: a collection of personal papers and organizational records documenting the United States&#39;s important history of capital punishment.</li>
							<li>
								<a href="http://library.albany.edu/archiveDev/mathes">Miriam Snow Mathes Historical Children's Literature Collection</a>:  includes over 12,000 children's books and periodicals published in the 19th century and up to 1960.</li>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/mss.html">Business, Literary, and Art Collection</a>: Chiefly New York State and New England business records, state and local history collections, and art and literary manuscripts.</li>
							<li>
								<a href="http://library.albany.edu/archiveDev/books">Rare and Specialized Books</a>: Pre-1801 European and pre-1820 American printed books</li>
						</ul>
						<ul>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/alpha.html">Alphabetical Listing of Collections</a>: An alphabetical listing of all manuscript and archival collections.</li>
							<li>
								<a href="http://library.albany.edu/speccoll/findaids/eresources/static/subjects.html">Subject Guides to Collections</a>: Selected subject listings of manuscript and archival collections.</li>
							<li>
								<a href="http://library.albany.edu/archiveDev/chronology">Chronological History of the University at Albany, SUNY</a>: Chronological History of the University at Albany, SUNY, 1844-2008</li>
						</ul>-->
					</div>
				</div>
			</div>
         </div>
      </form>
   </xsl:template>
   
   <!-- free-form form -->
   <xsl:template name="freeformForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <div class="form-group form-inline">
            <p class="help-block"><i>Experimental feature:</i> "Freeform" complex query supporting -/NOT, |/OR, &amp;/AND, field names, and parentheses.</p>
            <input class="form-control" type="text" name="freeformQuery" size="40" value="{$freeformQuery}"/>
            <xsl:text>&#160;</xsl:text>
            <input class="btn btn-primary" type="submit" value="Search"/>
            <input class="btn btn-default" type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
         </div>
         <h3>Examples:</h3>
                  <table class="table table-striped sampleTable">
                     <tr>
                        <td class="sampleQuery">africa</td>
                        <td class="sampleDescrip">Search keywords (full text and metadata) for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south &amp; africa</td>
                        <td class="sampleDescrip">(same)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south AND africa</td>
                        <td class="sampleDescrip">(same; note 'AND' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:south africa</td>
                        <td class="sampleDescrip">Search title for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">creator:moodley title:africa</td>
                        <td class="sampleDescrip">Search creator for 'moodley' AND title for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south | africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' OR 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south OR africa</td>
                        <td class="sampleDescrip">(same; note 'OR' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa -south</td>
                        <td class="sampleDescrip">Search keywords for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa NOT south</td>
                        <td class="sampleDescrip">(same; note 'NOT' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa -south</td>
                        <td class="sampleDescrip">Search title for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa subject:-politics</td>
                        <td class="sampleDescrip">
                           Search items with 'africa' in title but not 'politics' in subject.
                           Note '-' must follow ':'
                        </td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:-south</td>
                        <td class="sampleDescrip">Match all items without 'south' in title</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">-africa</td>
                        <td class="sampleDescrip">Match all items without 'africa' in keywords</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south (africa OR america)</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND either 'africa' OR 'america'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa OR america</td>
                        <td class="sampleDescrip">(same, due to precedence)</td>
                     </tr>
                  </table>
      </form>
   </xsl:template>
   
</xsl:stylesheet>
