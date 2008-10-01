--
-- Copyright (c) 2008 Red Hat, Inc.
--
-- This software is licensed to you under the GNU General Public License,
-- version 2 (GPLv2). There is NO WARRANTY for this software, express or
-- implied, including the implied warranties of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
-- along with this software; if not, see
-- http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
-- 
-- Red Hat trademarks are not licensed under GPLv2. No permission is
-- granted to use or replicate Red Hat trademarks that are incorporated
-- in this software or its documentation. 
--
--
--
--

create table
rhnServerPath
(
	server_id		number
				constraint rhn_serverpath_sid_nn not null
				constraint rhn_serverpath_sid_fk
					references rhnServer(id),
	proxy_server_id		number
				constraint rhn_serverpath_psid_nn not null
				constraint rhn_serverpath_psid_fk
					references rhnServer(id),
	position		number
				constraint rhn_serverpath_pos_nn not null,
	hostname		varchar2(256)
				constraint rhn_serverpath_hostname_nn not null,
	created			date default(sysdate)
				constraint rhn_serverpath_creat_nn not null,
	modified		date default(sysdate)
				constraint rhn_serverpath_mod_nn not null
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create unique index rhn_serverpath_sid_pos_uq
	on rhnServerPath( server_id, position )
	tablespace [[2m_tbs]]
	storage ( freelists 16 )
	initrans 32;

create unique index rhn_serverpath_psid_sid_uq
	on rhnServerPath( proxy_server_id, server_id )
	tablespace [[2m_tbs]]
	storage ( freelists 16 )
	initrans 32;

create or replace trigger rhn_serverpath_mod_trig
before insert or update on rhnServerPath
for each row
begin
	:new.modified := sysdate;
end;
/
show errors

--
--
-- Revision 1.3  2004/02/20 16:21:09  pjones
-- bugzilla: none -- this should have made the delete_server() mods last week
--
-- Revision 1.2  2004/01/06 23:02:22  pjones
-- bugzilla: none -- cascade deletes on rhnServerPath
--
-- Revision 1.1  2003/12/10 16:37:47  pjones
-- bugzilla: 111448 -- tables for path to server
--
