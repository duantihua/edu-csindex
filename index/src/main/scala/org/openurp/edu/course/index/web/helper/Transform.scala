/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.edu.course.index.web.helper

import java.util.regex.Pattern

object Transform {

  def getResultsFromHtml(htmlString: String): String = {
    val htmlTagRegEx = "<[a-zA-Z]+.*?>([\\s\\S]*?)<\\/[a-zA-Z ]*?>|<[a-zA-Z]+\\s\\/>"
    val p = Pattern.compile(htmlTagRegEx)
    var m = p.matcher(htmlString)
    var result = htmlString
    while (m.find) {
      result = m.replaceAll("$1")
      m = p.matcher(result)
    }
    result.trim
  }
}
