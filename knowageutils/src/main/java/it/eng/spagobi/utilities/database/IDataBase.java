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
package it.eng.spagobi.utilities.database;

import it.eng.spagobi.tools.dataset.cache.query.DatabaseDialect;
import it.eng.spagobi.tools.datasource.bo.IDataSource;

/**
 * @author Andrea Gioia (andrea.gioia@eng.it)
 *
 */
public interface IDataBase extends Comparable<IDataBase> {

	/**
	 * @return The database name
	 */
	String getName();

	/**
	 *
	 * @return the database dialect
	 */
	DatabaseDialect getDatabaseDialect();

	public abstract boolean isCacheSupported();

	/**
	 *
	 * @return the alias delimiter
	 */
	String getAliasDelimiter();

	/**
	 *
	 * @return the alias name used for sub queries in the FROM
	 */
	String getSubQueryAlias();

	public abstract IDataSource getDataSource();

	public abstract boolean isMetaSupported();
}
