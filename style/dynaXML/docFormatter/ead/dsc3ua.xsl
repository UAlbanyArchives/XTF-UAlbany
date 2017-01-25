
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf"
	xmlns="http://www.w3.org/1999/xhtml" version="1.0">

	<!-- This stylesheet formats the dsc where
	components have a single container element.-->
	<!--It assumes that c01 is a high-level description such as
	a series, subseries, subgroup or subcollection and does not have
	container elements associated with it.-->
	<!--Column headings for containers are inserted whenever
	the value of a container's type attribute differs from that of
	the container in the preceding component. -->
	<!-- The value of a column heading is taken from the type
    attribute of the container element.-->
	<!--The content of container elements is always displayed.-->
	<!-- c02 as subseries altered to provide anchor names when the info has been omitted -->


	<!-- .................Section 1.................. -->
	<!-- line break template -->

	<xsl:template match="lb">
		<br/>
	</xsl:template>
	
	<!-- paragraph break template -->
	
	<xsl:template match="p">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<!-- blockquote template -->
	
	<xsl:template match="blockquote">
		<p style="margin-left:1em">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--This section of the stylesheet formats dsc and
any introductory paragraphs.-->

	<xsl:template match="archdesc/dsc">
		<h3>Contents of Collection</h3>
		<xsl:choose>
		<xsl:when test="not(c01/@level='series' or c01/@level='subgrp')">
			<div class="row section">
				<div class="table-responsive">
				  <table class="table">
					<thead>
						<tr class="purpleHead">
							<th>
								<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request">Request</button>
							</th>
							<th>
								<xsl:text>Box</xsl:text>
							</th>
							<th>
								<xsl:text>Folder</xsl:text>
							</th>
							<th>
								<xsl:text>Contents</xsl:text>
							</th>
							<th>
								<xsl:text>Date</xsl:text>
							</th>
						</tr>
					</thead>
					<xsl:for-each select="c01">
						<xsl:call-template name="c02-level-container"/>
					</xsl:for-each>
				  </table>
				</div>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="c01|c">
				<xsl:call-template name="c01"/>
			</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--<xsl:template match="dsc/head">
		<a name="{../@id}" test="test"/>
		<h3><xsl:apply-templates/></h3>
	</xsl:template>

	<xsl:template match="dsc/p | dsc/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>-->

<!-- not for use in NYEAD at this time 
	<xsl:template name="did-dao">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="did/dao/@href"/>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:text>_blank</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="archdesc/dsc//did/dao"/>
			<img src="../xtf/icons/default/camicon.gif" border="0" alt="icon"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="dsc//unittitle/unitdate">
		<span class="clist_unitdate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- will  create separate line for work number when it is stated within a unittitle, followed by a title. 
		It may need to be rewritten to apply only to num as the first element within unittitle -->

	<xsl:template match="unittitle/num">
		<xsl:if test="following-sibling::title">
			<span class="worknumber">
				<xsl:apply-templates/>
				<br/>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- will  add a class for persname and a line break between personal name and title in unittitle -->

	<xsl:template match="unittitle/persname">
		<xsl:choose>
			<xsl:when test="following-sibling::persname[last()=1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:when>


			<xsl:when test="following-sibling::title[1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- will differentiate titles by type -->

	<xsl:template match="dsc//title">
		<xsl:choose>
			<xsl:when test="@type='uniform'">
				<span class="uniformtitle">
					<xsl:text>Uniform title: </xsl:text>
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='transcribed'">
				<span class="transcribedtitle">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='journal' or @type='book' or @render='italic'">
				<span class="italicstitle">
					<xsl:apply-templates/>
				</span>
			</xsl:when>

			<xsl:when test="@type='review' or @type='course' or @type='article' or @type='chapter'">
				<span class="quotestitle">
					<xsl:text>&#x201C;</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>&#x201D;</xsl:text>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="titlenotype">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ................Section 2 ...........................-->
	<!--This section of the stylesheet contains two templates
that are used generically throughout the stylesheet.-->

	<!--This template formats the unitid, origination, unittitle,
	unitdate, and physdesc elements of components at all levels.  They appear on
	a separate line from other did elements. It is generic to all
	component levels.-->

	<xsl:template name="component-did">
		<!--Inserts unitid and a space if it exists in the markup.-->

		<xsl:if test="unittitle/@label">
			<xsl:apply-templates select="unittitle/@label"/>
			<xsl:text>&#160;</xsl:text>
		</xsl:if>
		
		<xsl:if test="unitid">
			<xsl:apply-templates select="unitid"/>
			<xsl:text>&#58;</xsl:text>
			<xsl:text>&#160;</xsl:text>
		</xsl:if>

		<!--This choose statement selects between cases where unitdate is a child of
		unittitle and where it is a separate child of did.-->
		<xsl:choose>
			<!--This code processes the elements when unitdate is a child
			of unittitle.-->
			<!-- Does not allow for search result highlighting
			<xsl:when test="unitdate">
				<xsl:variable name="normaltitle">
					<xsl:value-of select="normalize-space(unittitle)"/>
				</xsl:variable>
				<xsl:apply-templates select="$normaltitle"/>
				<xsl:choose>
					<xsl:when test="ends-with(($normaltitle), ',')">
						<xsl:text>&#160;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>,&#160;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="unitdate">
					<xsl:variable name="normaldate">
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:variable>
					<xsl:apply-templates select="$normaldate"/>
					<xsl:if test="following-sibling::unitdate">
						<xsl:choose>
							<xsl:when test="ends-with(($normaldate), ',')"></xsl:when>
							<xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>-->
			
			<!-- Still allows for search results GW 5-6-16 -->
			<xsl:when test="unitdate">
				<xsl:for-each select="unittitle[name() != 'unitdate']">
					<xsl:choose>
						<xsl:when test="../dao">
							
							<xsl:choose>
								<xsl:when test=".='Contents'">
									<a class="hackContainerList">
										<xsl:attribute name="href">
											<xsl:value-of select="../dao/@href"/>
										</xsl:attribute>
										<xsl:apply-templates/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a>
										<xsl:attribute name="href">
											<xsl:value-of select="../dao/@href"/>
										</xsl:attribute>
										<xsl:apply-templates/>
									</a>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<!--This code process the elements when unitdate is not a
					child of untititle-->
			<xsl:otherwise>
				<xsl:for-each select="unittitle">
					<xsl:choose>
						<xsl:when test="../dao">
							<xsl:choose>
								<xsl:when test=".='Contents'">
									<a class="hackContainerList">
										<xsl:attribute name="href">
											<xsl:value-of select="../dao/@href"/>
										</xsl:attribute>
										<xsl:apply-templates/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a>
										<xsl:attribute name="href">
											<xsl:value-of select="../dao/@href"/>
										</xsl:attribute>
										<xsl:apply-templates/>
									</a>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ...............Section 3.............................. -->
	<!--This section of the stylesheet creates an HTML table for each c01.
It then recursively processes each child component of the
c01 by calling a named template specific to that component level.
The named templates are in section 4.-->

	<xsl:template name="c01">
		<xsl:for-each select=".">
			<a class="anchor">
				<xsl:attribute name="id">
					<xsl:value-of select="translate(@id, '.', '--')"/>
				</xsl:attribute>
			</a>
			<xsl:choose>
				<xsl:when test="c02/@level='subseries' or c02/@level='series' or c02/@level='subgrp'">
					<xsl:call-template name="c01-level"/>
					<xsl:for-each select="c02">
						<xsl:call-template name="c01"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="c03/@level='subseries' or c03/@level='series' or c03/@level='subgrp'">
					<xsl:call-template name="c01-level"/>
					<xsl:for-each select="c03">
						<xsl:call-template name="c01"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<div class="row section">
						<div>
						  <table class="table">
							<thead>
								<xsl:call-template name="c01-level"/>
								<xsl:if test="node()[starts-with(name(), 'c0')]">
									<tr class="purpleHead">
										<th>
											<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request">Request</button>
										</th>
										<th>
											<xsl:text>Box</xsl:text>
										</th>
										<th>
											<xsl:text>Folder</xsl:text>
										</th>
										<th>
											<xsl:text>Contents</xsl:text>
										</th>
										<th>
											<xsl:text>Date</xsl:text>
										</th>
									</tr>
								</xsl:if>
							</thead>
							<xsl:for-each select="node()[starts-with(name(), 'c0')]">
								<xsl:call-template name="c02-level-container"/>
							</xsl:for-each>
						  </table>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:for-each select="c02|c">
				<!--<xsl:choose>
					<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
							<xsl:call-template name="c02-level-subseries"/>
							<tr class="purpleHead">
							<th>
								<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request"><i class="glyphicon glyphicon-folder-close"/> Request</button>
							</th>
							<th>
								<xsl:text>Box</xsl:text>
							</th>
							<th>
								<xsl:text>Folder</xsl:text>
							</th>
							<th>
								<xsl:text>Contents</xsl:text>
							</th>
							<th>
								<xsl:text>Date</xsl:text>
							</th>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<div class="row">
							<xsl:call-template name="c02-level-container"/>
						</div>
					</xsl:otherwise>
				</xsl:choose>-->

				<xsl:for-each select="c03|c">
					<!--<xsl:choose>
						<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
							<xsl:call-template name="c02-level-subseries"/>
							<tr class="purpleHead">
								<th>
									<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request"><i class="glyphicon glyphicon-folder-close"/> Request</button>
								</th>
								<th>
									<xsl:text>Box</xsl:text>
								</th>
								<th>
									<xsl:text>Folder</xsl:text>
								</th>
								<th>
									<xsl:text>Contents</xsl:text>
								</th>
								<th>
									<xsl:text>Date</xsl:text>
								</th>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="c02-level-container"/>
						</xsl:otherwise>
					</xsl:choose>-->

					<xsl:for-each select="c04|c">
						<xsl:if
							test="@level='subseries' or @level='series' or @level='subgrp'">
							<xsl:call-template name="c02-level-subseries"/>
							<tr class="purpleHead">
								<th>
									<button type="button" class="btn btn-primary requestModel" data-toggle="modal" data-target="#request"><i class="glyphicon glyphicon-folder-close"/> Request</button>
								</th>
								<th>
									<xsl:text>Box</xsl:text>
								</th>
								<th>
									<xsl:text>Folder</xsl:text>
								</th>
								<th>
									<xsl:text>Contents</xsl:text>
								</th>
								<th>
									<xsl:text>Date</xsl:text>
								</th>
							</tr>
						</xsl:if>

						<xsl:for-each select="c05|c">
							<xsl:call-template name="c02-level-container"/>

							<xsl:for-each select="c06|c">
								<xsl:call-template name="c02-level-container"/>

								<xsl:for-each select="c07|c">
									<xsl:call-template name="c02-level-container"/>

									<xsl:for-each select="c08|c">
										<xsl:call-template name="c02-level-container"/>

										<xsl:for-each select="c09|c">
											<xsl:call-template name="c02-level-container"/>

											<xsl:for-each select="c10|c">
												<xsl:call-template name="c02-level-container"/>
											</xsl:for-each>
											<!--Closes c10-->
										</xsl:for-each>
										<!--Closes c09-->
									</xsl:for-each>
									<!--Closes c08-->
								</xsl:for-each>
								<!--Closes c07-->
							</xsl:for-each>
							<!--Closes c06-->
						</xsl:for-each>
						<!--Closes c05-->
					</xsl:for-each>
					<!--Closes c04-->
				</xsl:for-each>
				<!--Closes c03-->
			</xsl:for-each>
			<!--Closes c02-->
		</xsl:for-each>
		<!--Closes c01-->
	</xsl:template>

	<!-- ...............Section 4.............................. -->
	<!--This section of the stylesheet contains a separate named template for
each component level.  The contents of each is identical except for the
spacing that is inserted to create the proper column display in HTML
for each level.-->

	<!--Processes c01 which is assumed to be a series
	description without associated components.-->
	<xsl:template name="c01-level">
	
		<tr>
			<xsl:for-each select="did">
				<!--moved to start of cmpnt GW 5/9/16
				<a class="anchor">
					<xsl:attribute name="name">
						<xsl:value-of select="../@id"/>
					</xsl:attribute>
				</a>
				<xsl:if test="unitid/@id">
					<a>
						<xsl:attribute name="name">
							<xsl:value-of select="unitid/@id"/>
						</xsl:attribute>
					</a>
				</xsl:if>-->
					<div class="page-header">
						<h4>
							<p class="unitID">
								<xsl:attribute name="id">
									<xsl:text>ID-</xsl:text>
									<xsl:value-of select="translate(../@id, '.', '--')"/>
								</xsl:attribute>
								<xsl:value-of select="../@id"/>
							</p>
							<i class="fa fa-folder">
								<xsl:attribute name="onclick">
									<xsl:text>copyToClipboard('#ID-</xsl:text>
									<xsl:value-of select="translate(../@id, '.', '--')"/>
									<xsl:text>')</xsl:text>
								</xsl:attribute>
							</i>
							<xsl:text> </xsl:text>
							<div class="checkbox checkbox-primary">
							  <input type="checkbox" class="styled cmpntCheck">
									<xsl:attribute name="value">
										<xsl:if test="../accessrestrict">
											<xsl:text>RESTRICT</xsl:text>
										</xsl:if>
										<xsl:if test="../userestrict">
											<xsl:text>RESTRICT</xsl:text>
										</xsl:if>
										<xsl:value-of select="../@id"/>
										<xsl:text>: </xsl:text>
										<xsl:value-of select="unittitle"/>
									</xsl:attribute>
									<xsl:if test="dao">
										<xsl:if test="did/unittitle!='Contents'">
											<xsl:attribute name="disabled">
												<xsl:value-of select="disabled"/>
											</xsl:attribute>
										</xsl:if>
									</xsl:if>
							  </input><label></label>
							</div>
							<xsl:text> </xsl:text>
							<span><xsl:call-template name="component-did"/></span>
							<xsl:if test="unitdate">
								<xsl:for-each select="unitdate">
									<xsl:text>, </xsl:text>
									<xsl:apply-templates/>
								</xsl:for-each>
							</xsl:if>
							<xsl:if test="../accessrestrict | ../userestrict">
								<i class="glyphicon glyphicon-asterisk restrictIcon" data-toggle="collapse">
									<xsl:attribute name="data-target">
										<xsl:text>#restrict</xsl:text>
										<xsl:value-of select="translate(../@id, '.', '')"/>
									</xsl:attribute>
								</i>
							</xsl:if>
						</h4>
						<div style="clear:both;"></div>
					</div>
					<xsl:if test="../accessrestrict | ../userestrict">
						<div class="collapse col-sm-12 restrictDiv">
							<xsl:attribute name="id">
								<xsl:text>restrict</xsl:text>
								<xsl:value-of select="translate(../@id, '.', '')"/>
							</xsl:attribute>
							<span class="physdescLabel"><xsl:text>Restrictions:     </xsl:text></span>
							<xsl:for-each select="../accessrestrict | ../userestrict">
								<p>
									<xsl:apply-templates/>
								</p>
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:for-each select="physdesc">
						<div class="col-sm-12 physdescSeries">
							<span class="physdescLabel"><xsl:text>Quantity:     </xsl:text></span>
							<xsl:choose>
								<xsl:when test="extent or physfacet or dimensions">
									<xsl:if test="extent">
										<xsl:value-of select="extent"/>
									</xsl:if>
									<xsl:if test="extent/@unit">
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="contains(extent/@unit, 'cubic ft.')">
												<xsl:value-of select="extent/@unit"/><xsl:text> (about </xsl:text><xsl:value-of select="extent"/><xsl:text> boxes)</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="extent/@unit"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="physfacet">
										&#160;<xsl:value-of select="physfacet"/>
									</xsl:if>
									<xsl:if test="dimensions">
										<xsl:value-of select="dimensions"/>
									</xsl:if>
									<xsl:if test="dimensions/@unit">
										<xsl:text> </xsl:text>
										<xsl:value-of select="dimensions/@unit"/>
									</xsl:if>
									<xsl:if test="dimensions">
										&#160;
										<span id="firstDigital" class="digitalFiles glyphicon glyphicon-floppy-disk" data-toggle="tooltip" data-placement="top" title="Contains Online Content"></span>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="../../phystech">
								&#160;Web Archives&#160;
								<span id="webArch" class="webArchive fa fa-internet-explorer" data-toggle="tooltip" data-placement="top" title="Contains Web Archives"></span>
							</xsl:if>
						</div>
					</xsl:for-each>
					<xsl:for-each select="physloc | origination | note/p | langmaterial | materialspec">
						<div class="col-sm-12">
							<xsl:apply-templates/>
						</div>
					</xsl:for-each>
		
				
			</xsl:for-each>
			<!--Closes the did.-->

			<!--This template creates a separate row for each child of
			the listed elements. Do we need HEADS for these components? -->
			
			<xsl:for-each
				select="scopecontent | bioghist | arrangement  | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note
			| descgrp/*">
			
				<div class="col-md-6">
					<div class="panel panel-default">
						<div class="panel-heading" data-toggle="collapse">
						<xsl:attribute name="data-target">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="translate(../@id, '. ', '')" />
							<xsl:value-of select="name(.)"/>
						</xsl:attribute>
						  <h4 class="panel-title">
							<a><i class="glyphicon glyphicon-plus"/><xsl:text>  </xsl:text>
								<xsl:choose>
									<xsl:when test="name(.) = 'scopecontent'">
										<xsl:text>Contents</xsl:text>
									</xsl:when>
									<xsl:when test="name(.) = 'arrangement'">
										<xsl:text>Arrangement</xsl:text>
									</xsl:when>
									<xsl:when test="name(.) = 'bioghist'">
										<xsl:text>Historical Note</xsl:text>
									</xsl:when>
									<xsl:when test="name(.) = 'acqinfo'">
										<xsl:text>Acquisition Details</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>More Details</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						  </h4>
						</div>
						<div class="panel-collapse collapse">
						<xsl:attribute name="id">
							<xsl:text></xsl:text>
							<xsl:value-of select="translate(../@id, '. ', '')" />
							<xsl:value-of select="name(.)"/>
						</xsl:attribute>
						  <div class="panel-body">
								<xsl:for-each select="*[not(self::head)]">
									<xsl:apply-templates/>
								</xsl:for-each>
						  </div>
						</div>
					  </div>
				</div>
			</xsl:for-each>
			<div class="clearfix"></div>
		</tr>
	</xsl:template>

	<!--This template processes c02 elements that have associated containers, for
	example when c02 is a file.-->
	<xsl:template name="c02-level-container">
		<xsl:for-each select="did">
			
			<!--<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
				<div class="bg-primary col-md-12">
					<div class="col-md-1">
						
					</div>
					<div class="col-md-1">
						<xsl:value-of
							select="concat(translate(substring(container[1]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[1]/@type, 2))"
						/>
					</div>
					<div class="col-md-1">
						<xsl:value-of
							select="concat(translate(substring(container[2]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[2]/@type, 2))"
						/>
					</div>
					<div class="col-md-9">
						<xsl:text>Contents</xsl:text>
					</div>
				</div>
			</xsl:if>-->
			<tr itemscope="True" itemprop="associatedMedia" itemtype="https://schema.org/CreativeWork">
				<td class="requestColumn">
					<p class="unitID">
						<xsl:attribute name="id">
							<xsl:text>ID-</xsl:text>
							<xsl:value-of select="translate(../@id, '.', '--')"/>
						</xsl:attribute>
						<xsl:value-of select="../@id"/>
					</p>
					<i class="fa fa-folder">
						<xsl:attribute name="onclick">
							<xsl:text>copyToClipboard('#ID-</xsl:text>
							<xsl:value-of select="translate(../@id, '.', '--')"/>
							<xsl:text>')</xsl:text>
						</xsl:attribute>
					</i>
					<xsl:text>  </xsl:text>
					<div class="checkbox checkbox-primary">
					  <input type="checkbox" class="styled fileCheck">
							<xsl:attribute name="value">
								<xsl:if test="../accessrestrict">
									<xsl:text>RESTRICT</xsl:text>
								</xsl:if>
								<xsl:if test="../userestrict">
									<xsl:text>RESTRICT</xsl:text>
								</xsl:if>
								<xsl:value-of select="../@id"/>
								<xsl:text>: </xsl:text>
								<xsl:value-of select="unittitle"/>
							</xsl:attribute>
							<xsl:if test="..//dao">
								<xsl:if test="unittitle!='Contents'">
									<xsl:attribute name="disabled">
										<xsl:value-of select="disabled"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:if>
					  </input><label></label>
					</div>
				</td>
				<td>
					<xsl:if test="container[1]/@type != 'Box'">
						<xsl:value-of select="container[1]/@type"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of select="container[1]"/>
				</td>
				<td>
					<xsl:value-of select="container[2]"/>
				</td>
				<td itemprop="name">
					<xsl:attribute name="content">
						<xsl:value-of select="unittitle"/>
					</xsl:attribute>
					<xsl:call-template name="component-did"/>
					<xsl:if test="../accessrestrict | ../userestrict">
						<xsl:text> </xsl:text>
						<i class="glyphicon glyphicon-asterisk restrictIcon" data-toggle="collapse">
							<xsl:attribute name="data-target">
								<xsl:text>#restrict</xsl:text>
								<xsl:value-of select="translate(../@id, '. ', '')"/>
							</xsl:attribute>
						</i>
					</xsl:if>
					<xsl:if test="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec | ../scopecontent | ../bioghist | ../arrangement | ../processinfo |
					../acqinfo | ../custodhist | ../odd | ../note | ../descgrp/*">
					<xsl:text>     </xsl:text>
					<span class="glyphicon glyphicon-triangle-bottom moreBtn" data-toggle="collapse">
							<xsl:attribute name="data-target">
								<xsl:text>#more</xsl:text>
								<xsl:value-of select="translate(../@id, '. ', '')"/>
							</xsl:attribute>
					</span>
				</xsl:if>
				</td>
				<td>
					<xsl:for-each select="unitdate">
						<span itemprop="dateCreated">
							<xsl:attribute name="content">
								<xsl:value-of select="@normal"/>
							</xsl:attribute>
							<xsl:if test="not(position()=1)">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="." />
						</span>
					</xsl:for-each>
				</td>
			
			
			
			
		</tr>
		
		
		
		<xsl:if test="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec | ../scopecontent | ../bioghist | ../arrangement | ../processinfo |
			../acqinfo | ../custodhist | ../odd | ../note | ../descgrp/*">
				<tr class="hiddenRow">
				<td colspan="3"></td>
				<td colspan="4">
				<div class="collapse moreDiv">
					<xsl:attribute name="id">
						<xsl:text>more</xsl:text>
						<xsl:value-of select="translate(../@id, '. ', '')"/>
					</xsl:attribute>
					<xsl:for-each select="physdesc">
						<xsl:if test = "text()">
							<p><xsl:value-of select="."/></p>
						</xsl:if>
						<xsl:for-each select="extent">
							<p><xsl:value-of select="."/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="@unit"/></p>
						</xsl:for-each>
						<xsl:for-each select="physfacet">
							<p><xsl:value-of select="."/></p>
						</xsl:for-each>
						<xsl:for-each select="dimensions">
							<p><xsl:value-of select="."/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="@unit"/></p>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="../acqinfo">
							<xsl:for-each select="p">
								<xsl:choose>
									<xsl:when test="date">
										<p><xsl:value-of select="date"/><xsl:text>: </xsl:text><xsl:value-of select="text()"/></p>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<xsl:value-of select="."/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:for-each>
						<xsl:for-each select="../scopecontent">
							<p><xsl:apply-templates/></p>
						</xsl:for-each>
					<xsl:for-each select="physloc| origination | abstract | note/p | langmaterial | materialspec | ../bioghist | ../arrangement | ../processinfo |
				 ../custodhist | ../odd | ../note | ../descgrp/*">
						<xsl:apply-templates/>
					</xsl:for-each>
				</div>
				</td>
			</tr>
		</xsl:if>
		
		<xsl:if test="../accessrestrict | ../userestrict">
			<tr class="hiddenRow">
				<td colspan="8">
					<div class="collapse restrictDiv">
						<xsl:attribute name="id">
							<xsl:text>restrict</xsl:text>
							<xsl:value-of select="translate(../@id, '. ', '')"/>
						</xsl:attribute>
						<xsl:for-each select="../accessrestrict | ../userestrict">
							<xsl:apply-templates/>
						</xsl:for-each>
					</div>
				</td>
			</tr>
		</xsl:if>
		
			<!-- Item-level -->
			<xsl:for-each select="../node()[starts-with(name(), 'c0')]/did">
				<tr>
					<td>
						

						<div class="checkbox checkbox-primary">
						  <input type="checkbox" class="styled fileCheck" id="singleCheckbox1" aria-label="Single checkbox One">
								<xsl:attribute name="value">
									<xsl:value-of select="../@id"/>
								</xsl:attribute>
								<xsl:if test="dao">
								<xsl:attribute name="disabled">
									<xsl:text>disabled</xsl:text>
								</xsl:attribute>
								</xsl:if>
								<xsl:if test="..//dao">
									<xsl:if test="unittitle!='Contents'">
										<xsl:attribute name="disabled">
											<xsl:value-of select="disabled"/>
										</xsl:attribute>
									</xsl:if>						
								</xsl:if>
						  </input><label></label>
						</div>
					</td>
					<td>
						<xsl:if test="container[1]/@type != 'Box'">
							<xsl:value-of select="container[1]/@type"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="container[1]"/>
					</td>
					<td>
						<xsl:value-of select="container[2]"/>
					</td>
					<td>
						<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
						<p class="unitID">
							<xsl:attribute name="id">
								<xsl:text>ID-</xsl:text>
								<xsl:value-of select="translate(../@id, '.', '--')"/>
							</xsl:attribute>
							<xsl:value-of select="../@id"/>
						</p>
						<i class="fa fa-file-text">
							<xsl:attribute name="onclick">
								<xsl:text>copyToClipboard('#ID-</xsl:text>
								<xsl:value-of select="translate(../@id, '.', '--')"/>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</i>
						<xsl:text>&#160;&#160;</xsl:text>
						<xsl:call-template name="component-did"/>
						<xsl:if test="../accessrestrict | ../userestrict">
							<xsl:text> </xsl:text>
							<i class="glyphicon glyphicon-asterisk restrictIcon" data-toggle="collapse">
								<xsl:attribute name="data-target">
									<xsl:text>#restrict</xsl:text>
									<xsl:value-of select="translate(../@id, '. ', '')"/>
								</xsl:attribute>
							</i>
						</xsl:if>
						<xsl:if test="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec | ../scopecontent | ../bioghist | ../arrangement | ../processinfo |
						../acqinfo | ../custodhist | ../odd | ../note | ../descgrp/*">
						<xsl:text>     </xsl:text>
						<span class="glyphicon glyphicon-triangle-bottom moreBtn" data-toggle="collapse">
								<xsl:attribute name="data-target">
									<xsl:text>#more</xsl:text>
									<xsl:value-of select="translate(../@id, '. ', '')"/>
								</xsl:attribute>
						</span>
					</xsl:if>
					</td>
					<td>
						<xsl:for-each select="unitdate">
							<xsl:if test="not(position()=1)">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="." />
						</xsl:for-each>
					</td>
				
				
				
				
				</tr>
				<xsl:if test="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec | ../scopecontent | ../bioghist | ../arrangement | ../processinfo |
				../acqinfo | ../custodhist | ../odd | ../note | ../descgrp/*">
					<tr class="hiddenRow">
					<td colspan="3"></td>
					<td colspan="4">
					<div class="collapse moreDiv">
						<xsl:attribute name="id">
							<xsl:text>more</xsl:text>
							<xsl:value-of select="translate(../@id, '. ', '')"/>
						</xsl:attribute>
						<xsl:for-each select="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec | ../scopecontent | ../bioghist | ../arrangement | ../processinfo |
					../acqinfo | ../custodhist | ../odd | ../note | ../descgrp/*">
							<p>
								<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
								<xsl:apply-templates/>
							</p>
						</xsl:for-each>
					</div>
					</td>
				</tr>
			</xsl:if>
			
			<xsl:if test="../accessrestrict | ../userestrict">
				<tr class="hiddenRow">
					<td colspan="8">
						<div class="collapse restrictDiv">
							<xsl:attribute name="id">
								<xsl:text>restrict</xsl:text>
								<xsl:value-of select="translate(../@id, '. ', '')"/>
							</xsl:attribute>
							<xsl:for-each select="../accessrestrict | ../userestrict">
								<p>
									<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
									<xsl:apply-templates/>
								</p>
							</xsl:for-each>
						</div>
					</td>
				</tr>
			</xsl:if>
			</xsl:for-each>
		
		</xsl:for-each>
		<!--Closes the did.-->
	</xsl:template>

	<!--This template processes c02 level components that do not have
	associated containers, for example if the c02 is a subseries.-->


	<xsl:template name="c02-level-subseries">
		<xsl:for-each select="did">
			<a>
				<xsl:attribute name="name">
					<xsl:value-of select="../@id"/>
				</xsl:attribute>
			</a>
			<xsl:if test="unitid/@id">
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="unitid/@id"/>
					</xsl:attribute>
				</a>
			</xsl:if>
			<div class="col-md-12">
				<h4>
					<xsl:call-template name="component-did"/>
				</h4>
			</div>
			<xsl:for-each
				select="physdesc | physloc| origination | note/p | langmaterial | materialspec">
				<div class="col-md-12">
					<xsl:apply-templates/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<!--Closes the did.-->

		<!--This template creates a separate row for each child of
				the listed elements. Do we need HEADS for these components? -->
		<xsl:for-each
			select="scopecontent | bioghist | arrangement 
				| userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note
				| descgrp/*">
			<div class="col-md-12">
				<xsl:for-each select="head">
					<h5>
						<xsl:apply-templates/>
					</h5>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<xsl:apply-templates/>
				</xsl:for-each>
			</div>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>
