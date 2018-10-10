package it.eng.spagobi.metadata.metadata;

// Generated 12-apr-2016 10.43.25 by Hibernate Tools 3.4.0.CR1

import it.eng.spagobi.commons.metadata.SbiHibernateModel;

import java.util.HashSet;
import java.util.Set;

/**
 * SbiMetaJob generated by hbm2java
 */
public class SbiMetaJob extends SbiHibernateModel {

	private Integer jobId;
	private String name;
	private boolean deleted;
	private Set sbiMetaJobSources = new HashSet(0);
	private Set sbiMetaJobTables = new HashSet(0);

	public SbiMetaJob() {
	}

	public SbiMetaJob(String name, boolean deleted) {
		this.name = name;
		this.deleted = deleted;
	}

	public SbiMetaJob(String name, boolean deleted, Set sbiMetaJobSources, Set sbiMetaJobTables) {
		this.name = name;
		this.deleted = deleted;
		this.sbiMetaJobSources = sbiMetaJobSources;
		this.sbiMetaJobTables = sbiMetaJobTables;
	}

	public Integer getJobId() {
		return this.jobId;
	}

	public void setJobId(Integer jobId) {
		this.jobId = jobId;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isDeleted() {
		return this.deleted;
	}

	public void setDeleted(boolean deleted) {
		this.deleted = deleted;
	}

	public Set getSbiMetaJobSources() {
		return this.sbiMetaJobSources;
	}

	public void setSbiMetaJobSources(Set sbiMetaJobSources) {
		this.sbiMetaJobSources = sbiMetaJobSources;
	}

	public Set getSbiMetaJobTables() {
		return this.sbiMetaJobTables;
	}

	public void setSbiMetaJobTables(Set sbiMetaJobTables) {
		this.sbiMetaJobTables = sbiMetaJobTables;
	}

}
