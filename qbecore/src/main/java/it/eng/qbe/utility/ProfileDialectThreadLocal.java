/*
 * Knowage, Open Source Business Intelligence suite
 * Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.
 *
 * Knowage is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Knowage is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package it.eng.qbe.utility;

import it.eng.spagobi.commons.bo.UserProfile;

/**
 * @author Davide Zerbetto (davide.zerbetto@eng.it)
 */
public class ProfileDialectThreadLocal {

	private static final ThreadLocal<UserProfile> _userProfile = new ThreadLocal<UserProfile>();
	private static final ThreadLocal<String> _dialect = new ThreadLocal<String>();

	public static void setUserProfile(UserProfile userProfile) {
		_userProfile.set(userProfile);
	}

	public static UserProfile getUserProfile() {
		return _userProfile.get();
	}

	public static void setDialect(String dialect) {
		_dialect.set(dialect);
	}

	public static String getDialect() {
		return _dialect.get();
	}

	public static void unset() {
		_userProfile.remove();
		_dialect.remove();

	}

}
