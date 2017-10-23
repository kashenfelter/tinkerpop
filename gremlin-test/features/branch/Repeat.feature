# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

Feature: Step - repeat()

  Scenario: g_V_repeatXoutX_timesX2X_emit_path
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.out()).times(2).emit().path()
      """
    When iterated to list
    Then the result should be unordered
      | p[v[marko],v[lop]] |
      | p[v[marko],v[vadas]] |
      | p[v[marko],v[josh]] |
      | p[v[marko],v[josh],v[ripple]] |
      | p[v[marko],v[josh],v[lop]] |
      | p[v[josh],v[ripple]] |
      | p[v[josh],v[lop]] |
      | p[v[peter],v[lop]] |

  Scenario: g_V_repeatXoutX_timesX2X_repeatXinX_timesX2X_name
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.out()).times(2).repeat(__.in()).times(2).values("name")
      """
    When iterated to list
    Then the result should be unordered
      | marko |
      | marko |

  Scenario: g_V_repeatXoutX_timesX2X
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.out()).times(2) 
      """
    When iterated to list
    Then the result should be unordered
      | v[ripple] |
      | v[lop] |

  Scenario: g_V_repeatXoutX_timesX2X_emit
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.out()).times(2).emit()
      """
    When iterated to list
    Then the result should be of
      | v[ripple] |
      | v[lop] |
      | v[josh] |
      | v[vadas] |
    And only have a result count of 8

  Scenario: g_VX1X_timesX2X_repeatXoutX_name
    Given the modern graph
    And using the parameter v1Id defined as "v[marko].id"
    And the traversal of
      """
      g.V(v1Id).times(2).repeat(__.out()).values("name")
      """
    When iterated to list
    Then the result should be unordered
      | ripple |
      | lop |

  Scenario: g_V_emit_timesX2X_repeatXoutX_path
    Given the modern graph
    And the traversal of
      """
      g.V().emit().times(2).repeat(__.out()).path()
      """
    When iterated to list
    Then the result should be unordered
      | p[v[marko]] |
      | p[v[marko],v[lop]] |
      | p[v[marko],v[vadas]] |
      | p[v[marko],v[josh]] |
      | p[v[marko],v[josh],v[ripple]] |
      | p[v[marko],v[josh],v[lop]] |
      | p[v[vadas]] |
      | p[v[lop]] |
      | p[v[josh]] |
      | p[v[josh],v[ripple]] |
      | p[v[josh],v[lop]] |
      | p[v[ripple]] |
      | p[v[peter]] |
      | p[v[peter],v[lop]] |

  Scenario: g_V_emit_repeatXoutX_timesX2X_path
    Given the modern graph
    And the traversal of
      """
      g.V().emit().repeat(__.out()).times(2).path()
      """
    When iterated to list
    Then the result should be unordered
      | p[v[marko]] |
      | p[v[marko],v[lop]] |
      | p[v[marko],v[vadas]] |
      | p[v[marko],v[josh]] |
      | p[v[marko],v[josh],v[ripple]] |
      | p[v[marko],v[josh],v[lop]] |
      | p[v[vadas]] |
      | p[v[lop]] |
      | p[v[josh]] |
      | p[v[josh],v[ripple]] |
      | p[v[josh],v[lop]] |
      | p[v[ripple]] |
      | p[v[peter]] |
      | p[v[peter],v[lop]] |

  Scenario: g_VX1X_emitXhasXlabel_personXX_repeatXoutX_name
    Given the modern graph
    And using the parameter v1Id defined as "v[marko].id"
    And the traversal of
      """
      g.V(v1Id).emit(__.has(T.label, "person")).repeat(__.out()).values("name")
      """
    When iterated to list
    Then the result should be unordered
      | marko |
      | vadas |
      | josh  |

  Scenario: g_V_repeatXgroupCountXmX_byXnameX_outX_timesX2X_capXmX
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.groupCount("m").by("name").out()).times(2).cap("m")
      """
    When iterated to list
    Then the result should be unordered
      | m[{"ripple":2,"peter":1,"vadas":2,"josh":2,"lop":4,"marko":1}] |

  Scenario: g_VX1X_repeatXgroupCountXmX_byXloopsX_outX_timesX3X_capXmX
    Given the modern graph
    And using the parameter v1Id defined as "v[marko].id"
    And the traversal of
      """
      g.V(v1Id).repeat(__.groupCount("m").by(__.loops()).out()).times(3).cap("m")
      """
    When iterated to list
    Then nothing should happen because
      """
      The result returned is not supported under GraphSON 2.x and therefore cannot be properly asserted. More
      specifically it has long keys which basically get toString()'d under GraphSON 2.x. This test can be supported
      with GraphSON 3.x.
      """

  Scenario: g_V_repeatXbothX_timesX10X_asXaX_out_asXbX_selectXa_bX
    Given the modern graph
    And the traversal of
      """
      g.V().repeat(__.both()).times(10).as("a").out().as("b").select("a", "b").count()
      """
    When iterated to list
    Then the result should be ordered
      | d[43958] |

  Scenario: g_VX1X_repeatXoutX_untilXoutE_count_isX0XX_name
    Given the modern graph
    And using the parameter v1Id defined as "v[marko].id"
    And the traversal of
      """
      g.V(v1Id).repeat(__.out()).until(__.outE().count().is(0)).values("name")
      """
    When iterated to list
    Then the result should be unordered
      | lop |
      | vadas |
      | ripple  |
      | lop  |

  Scenario: g_V_repeatXbothX_untilXname_eq_marko_or_loops_gt_1X_groupCount_byXnameX
    Given the modern graph
    And using the parameter v1Id defined as "v[marko].id"
    And using the parameter l defined as "c[t -> t.get().value('name').equals('lop') || t.loops() > 1]"
    And the traversal of
      """
      g.V().repeat(__.both()).until(l).groupCount().by("name")
      """
    When iterated to list
    Then the result should be unordered
      | m[{"ripple":3,"vadas":3,"josh":4,"lop":10,"marko":4}] |

  Scenario: g_V_hasXname_markoX_repeatXoutE_inV_simplePathX_untilXhasXname_rippleXX_path_byXnameX_byXlabelX
    Given the modern graph
    And the traversal of
      """
      g.V().has("name", "marko").repeat(__.outE().inV().simplePath()).until(__.has("name", "ripple")).path().by("name").by(T.label)
      """
    When iterated next
    Then the result should be unordered
      | marko |
      | knows |
      | josh  |
      | created |
      | ripple  |
