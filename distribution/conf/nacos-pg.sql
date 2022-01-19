/*
 Navicat Premium Data Transfer

 Source Server         : localhost-nacos_config
 Source Server Type    : PostgreSQL
 Source Server Version : 120002
 Source Host           : localhost:5432
 Source Catalog        : nacos_config
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 120002
 File Encoding         : 65001

 @author wangtan
 @date 2021-06-14 14:10:29
 @since 1.0
*/

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info   */
/******************************************/
CREATE TABLE config_info
(
    id           bigserial    NOT NULL,
    data_id      varchar(255) NOT NULL,
    group_id     varchar(255)          DEFAULT NULL,
    content      text         NOT NULL,
    md5          varchar(32)           DEFAULT NULL,
    gmt_create   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    src_user     text,
    src_ip       varchar(50)           DEFAULT NULL,
    app_name     varchar(128)          DEFAULT NULL,
    tenant_id    varchar(128)          DEFAULT '',
    c_desc       varchar(256)          DEFAULT NULL,
    c_use        varchar(64)           DEFAULT NULL,
    effect       varchar(64)           DEFAULT NULL,
    type         varchar(64)           DEFAULT NULL,
    c_schema     text,
    PRIMARY KEY (id),
    constraint uk_configinfo_datagrouptenant unique (data_id, group_id, tenant_id)
);


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_aggr   */
/******************************************/
CREATE TABLE config_info_aggr
(
    id           bigserial    NOT NULL,
    data_id      varchar(255) NOT NULL,
    group_id     varchar(255) NOT NULL,
    datum_id     varchar(255) NOT NULL,
    "content"    text         NOT NULL,
    gmt_modified timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    app_name     varchar(128)          DEFAULT NULL,
    tenant_id    varchar(128)          DEFAULT '',
    PRIMARY KEY (id),
    constraint uk_configinfoaggr_datagrouptenantdatum unique (data_id, group_id, tenant_id, datum_id)
);
comment
on table config_info_aggr is '增加租户字段';
comment
on column config_info_aggr."content" is '内容';
comment
on column config_info_aggr.gmt_modified is '修改时间';
comment
on column config_info_aggr.tenant_id is '租户字段';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_beta   */
/******************************************/
CREATE TABLE config_info_beta
(
    id           bigserial    NOT NULL,
    data_id      varchar(255) NOT NULL,
    group_id     varchar(128) NOT NULL,
    app_name     varchar(128)          DEFAULT NULL,
    "content"    text         NOT NULL,
    beta_ips     varchar(1024)         DEFAULT NULL,
    md5          varchar(32)           DEFAULT NULL,
    gmt_create   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    src_user     text,
    src_ip       varchar(50)           DEFAULT NULL,
    tenant_id    varchar(128)          DEFAULT '',
    PRIMARY KEY (id),
    constraint uk_configinfobeta_datagrouptenant unique (data_id, group_id, tenant_id)
);
comment
on column config_info_beta.gmt_create is '创建时间';
comment
on column config_info_beta.gmt_modified is '修改时间';
comment
on column config_info_beta.tenant_id is '租户字段';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_tag   */
/******************************************/
CREATE TABLE config_info_tag
(
    id           bigserial    NOT NULL,
    data_id      varchar(255) NOT NULL,
    group_id     varchar(128) NOT NULL,
    tenant_id    varchar(128)          DEFAULT '',
    tag_id       varchar(128) NOT NULL,
    app_name     varchar(128)          DEFAULT NULL,
    content      text         NOT NULL,
    md5          varchar(32)           DEFAULT NULL,
    gmt_create   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    src_user     text,
    src_ip       varchar(50)           DEFAULT NULL,
    PRIMARY KEY (id),
    constraint uk_configinfotag_datagrouptenanttag unique (data_id, group_id, tenant_id, tag_id)
);
comment
on column config_info_tag.gmt_create is '创建时间';
comment
on column config_info_tag.gmt_modified is '修改时间';
comment
on column config_info_tag.tenant_id is '租户字段';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_tags_relation   */
/******************************************/
CREATE TABLE config_tags_relation
(
    id        bigint       NOT NULL,
    tag_name  varchar(128) NOT NULL,
    tag_type  varchar(64)  DEFAULT NULL,
    data_id   varchar(255) NOT NULL,
    group_id  varchar(128) NOT NULL,
    tenant_id varchar(128) DEFAULT '',
    nid       bigserial    NOT NULL,
    PRIMARY KEY (nid),
    constraint uk_configtagrelation_configidtag unique (id, tag_name, tag_type)
);

CREATE INDEX idx_tenant_id ON config_tags_relation (tenant_id);


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = group_capacity   */
/******************************************/
CREATE TABLE group_capacity
(
    id                bigserial    NOT NULL,
    group_id          varchar(128) NOT NULL DEFAULT '',
    quota             int4         NOT NULL DEFAULT '0',
    "usage"           int4         NOT NULL DEFAULT '0',
    max_size          int4         NOT NULL DEFAULT '0',
    max_aggr_count    int4         NOT NULL DEFAULT '0',
    max_aggr_size     int4         NOT NULL DEFAULT '0',
    max_history_count int4         NOT NULL DEFAULT '0',
    gmt_create        timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    constraint uk_group_id unique (group_id)
);
comment
on table group_capacity is '集群、各Group容量信息表';
comment
on column group_capacity.gmt_create is '创建时间';
comment
on column group_capacity.gmt_modified is '修改时间';
comment
on column group_capacity.max_history_count is '最大变更历史数量';
comment
on column group_capacity.max_aggr_size is '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值';
comment
on column group_capacity.max_aggr_count is '聚合子配置最大个数，，0表示使用默认值';
comment
on column group_capacity.max_size is '单个配置大小上限，单位为字节，0表示使用默认值';
comment
on column group_capacity."usage" is '使用量';
comment
on column group_capacity.quota is '配额，0表示使用默认值';
comment
on column group_capacity.id is '主键id';
comment
on column group_capacity.group_id is 'Group ID，空字符表示整个集群';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = his_config_info   */
/******************************************/
CREATE TABLE his_config_info
(
    id           bigint       NOT NULL,
    nid          bigserial    NOT NULL,
    data_id      varchar(255) NOT NULL,
    group_id     varchar(128) NOT NULL,
    app_name     varchar(128)          DEFAULT NULL,
    "content"    text         NOT NULL,
    md5          varchar(32)           DEFAULT NULL,
    gmt_create   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    src_user     text,
    src_ip       varchar(50)           DEFAULT NULL,
    op_type      char(10)              DEFAULT NULL,
    tenant_id    varchar(128)          DEFAULT '',
    PRIMARY KEY (nid)
);
CREATE INDEX idx_gmt_create ON his_config_info (gmt_create);
CREATE INDEX idx_gmt_modified ON his_config_info (gmt_modified);
CREATE INDEX idx_did ON his_config_info (data_id);


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = tenant_capacity   */
/******************************************/
CREATE TABLE tenant_capacity
(
    id                bigserial    NOT NULL,
    tenant_id         varchar(128) NOT NULL DEFAULT '',
    quota             int4         NOT NULL DEFAULT '0',
    "usage"           int4         NOT NULL DEFAULT '0',
    max_size          int4         NOT NULL DEFAULT '0',
    max_aggr_count    int4         NOT NULL DEFAULT '0',
    max_aggr_size     int4         NOT NULL DEFAULT '0',
    max_history_count int4         NOT NULL DEFAULT '0',
    gmt_create        timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    gmt_modified      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    constraint uk_tenant_id unique (tenant_id)
);
comment
on table tenant_capacity is '租户容量信息表';
comment
on column tenant_capacity.gmt_create is '创建时间';
comment
on column tenant_capacity.gmt_modified is '修改时间';
comment
on column tenant_capacity.max_history_count is '最大变更历史数量';
comment
on column tenant_capacity.max_aggr_size is '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值';
comment
on column tenant_capacity.max_aggr_count is '聚合子配置最大个数，，0表示使用默认值';
comment
on column tenant_capacity.max_size is '单个配置大小上限，单位为字节，0表示使用默认值';
comment
on column tenant_capacity."usage" is '使用量';
comment
on column tenant_capacity.quota is '配额，0表示使用默认值';
comment
on column tenant_capacity.id is '主键id';


CREATE TABLE tenant_info
(
    id            bigserial    NOT NULL,
    kp            varchar(128) NOT NULL,
    tenant_id     varchar(128) default '',
    tenant_name   varchar(128) default '',
    tenant_desc   varchar(256) DEFAULT NULL,
    create_source varchar(32)  DEFAULT NULL,
    gmt_create    int8         NOT NULL,
    gmt_modified  int8         NOT NULL,
    PRIMARY KEY (id),
    constraint uk_tenant_info_kptenantid unique (kp, tenant_id)
);
comment
on column tenant_info.gmt_create is '创建时间';
comment
on column tenant_info.gmt_modified is '修改时间';
comment
on column tenant_info.id is '主键id';

CREATE INDEX idx_tenant_info_tenant_id ON tenant_info (tenant_id);


CREATE TABLE users
(
    username   varchar(50)  NOT NULL PRIMARY KEY,
    "password" varchar(500) NOT NULL,
    enabled    boolean      NOT NULL
);

CREATE TABLE roles
(
    username varchar(50) NOT NULL,
    "role"   varchar(50) NOT NULL
);
CREATE INDEX idx_user_role ON roles (username, "role");

CREATE TABLE permissions
(
    "role"   varchar(50)  NOT NULL,
    resource varchar(255) NOT NULL,
    "action" varchar(8)   NOT NULL
);
CREATE INDEX uk_role_permission ON permissions ("role", resource, "action");

INSERT INTO users (username, password, enabled)
VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);

INSERT INTO roles (username, role)
VALUES ('nacos', 'ROLE_ADMIN');


