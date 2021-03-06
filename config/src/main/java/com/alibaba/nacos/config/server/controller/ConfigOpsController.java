/*
 * Copyright 1999-2018 Alibaba Group Holding Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.alibaba.nacos.config.server.controller;

import com.alibaba.nacos.config.server.constant.Constants;
import com.alibaba.nacos.config.server.service.dump.DumpService;
import com.alibaba.nacos.config.server.service.repository.PersistService;
import com.alibaba.nacos.config.server.utils.LogUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;

/**
 * Manage controllers.
 *
 * @author Nacos
 */
@RestController
@RequestMapping(Constants.OPS_CONTROLLER_PATH)
public class ConfigOpsController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ConfigOpsController.class);

    protected final PersistService persistService;

    private final DumpService dumpService;

    @Autowired
    public ConfigOpsController(PersistService persistService, DumpService dumpService) {
        this.persistService = persistService;
        this.dumpService = dumpService;
    }

    /**
     * Manually trigger dump of a local configuration file.
     */
    @PostMapping(value = "/localCache")
    public String updateLocalCacheFromStore() {
        LOGGER.info("start to dump all data from store.");
        dumpService.dumpAll();
        LOGGER.info("finish to dump all data from store.");
        return HttpServletResponse.SC_OK + "";
    }

    //@PutMapping(value = "/log")
    @PostMapping(value = "/log")
    public String setLogLevel(@RequestParam String logName, @RequestParam String logLevel) {
        LogUtil.setLogLevel(logName, logLevel);
        return HttpServletResponse.SC_OK + "";
    }
}
