#!/bin/bash

#
# Copyright (C) 2012 Benjamin Eikel <eikel@upb.de>
#
# This file is free software: you can redistribute it and/or 
# modify it under the terms of the Lesser GNU General Public License 
# as published by the Free Software Foundation, either version 3 of 
# the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this file. If not, see <http://www.gnu.org/licenses/>.
#

if [ ! -d src ]
then
    echo "ERROR: You must run the script from the PADrend root directory."
    exit 1
fi

rm -r -f statsvn
mkdir statsvn

for SVN_DIR in src/*
do
    if [ -d "${SVN_DIR}/.svn" ]
    then
        XML_FILE=statsvn/${SVN_DIR/src\//}.xml
        svn log -v --xml "${SVN_DIR}" > "${XML_FILE}"
        statsvn -config-file resources/Documentation/PADrend-statsvn-config \
                -output-dir "statsvn/${SVN_DIR/src\//}" \
                "${XML_FILE}" \
                "${SVN_DIR}"
    fi
done
exit 0
