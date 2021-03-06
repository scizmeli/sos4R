################################################################################
# Copyright (C) 2015 by 52 North                                               #
# Initiative for Geospatial Open Source Software GmbH                          #
#                                                                              #
# Contact: Andreas Wytzisk                                                     #
# 52 North Initiative for Geospatial Open Source Software GmbH                 #
# Martin-Luther-King-Weg 24                                                    #
# 48155 Muenster, Germany                                                      #
# info@52north.org                                                             #
#                                                                              #
# This program is free software; you can redistribute and/or modify it under   #
# the terms of the GNU General Public License version 2 as published by the    #
# Free Software Foundation.                                                    #
#                                                                              #
# This program is distributed WITHOUT ANY WARRANTY; even without the implied   #
# WARRANTY OF MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU #
# General Public License for more details.                                     #
#                                                                              #
# You should have received a copy of the GNU General Public License along with #
# this program (see gpl-2.0.txt). If not, write to the Free Software           #
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA or #
# visit the Free Software Foundation web page, http://www.fsf.org.             #
#                                                                              #
# Author: Daniel Nuest (daniel.nuest@uni-muenster.de)                          #
# Created: 2011-02-09                                                          #
# Project: sos4R - visit the project web page, http://www.nordholmen.net/sos4r #
#                                                                              #
################################################################################

#
#
#
as.SosObservationOffering.SpatialPolygons = function(from) {
	# create bounding polygon from offering bounding box
	.bbox <- sosBoundedBy(from, bbox = TRUE)
	.llat <- .bbox["coords.lat","min"]
	.llon <- .bbox["coords.lon","min"]
	.ulat <- .bbox["coords.lat","max"]
	.ulon <- .bbox["coords.lon","max"]
	
	.crs <- sosGetCRS(from)
	if(is.null(.crs)) {
		warning(paste("Cannot coerce offering", sosId(from),
						"to SpatialPolygons -- no CRS given."))
		return(NULL)
	}
	
	# beginning at lower left corner:
	.poly <- Polygon(cbind(c(.llon, .llon, .ulon, .ulon, .llon),
					c(.llat, .ulat, .ulat, .llat, .llat)))
	.spPoly <- SpatialPolygons(list(
					Polygons(list(.poly), sosName(from))),
			proj4string = .crs)
	
	return(.spPoly)
}
setAs("SosObservationOffering", "SpatialPolygons", 
		function(from) {
			as.SosObservationOffering.SpatialPolygons(from)
		}
)
setAs("SosObservationOffering", "Spatial", 
		function(from) {
			as.SosObservationOffering.SpatialPolygons(from)
		}
)
