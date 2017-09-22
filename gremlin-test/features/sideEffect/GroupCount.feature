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

Feature: Step - groupCount()

  Scenario: Group count vertices that have incoming created edges by their name
    Given the modern graph
    And the traversal of
      """
      g.V().out("created").groupCount().by("name")
      """
    When iterated to list
    Then the result should be ordered
      | map | {"ripple": 1, "lop": 3} |

  Scenario: Edge count distribution
    Given the modern graph
    And the traversal of
      """
      g.V().groupCount().by(bothE().count())
      """
    When iterated to list
    Then the result should be ordered
      | map | {"d[1]": 3, "d[3]": 3} |

  Scenario: Group count vertices, cap to retrieve the map and unfold it to group count again
    Given the modern graph
    And the traversal of
      """
      g.V().both().groupCount("a").out().cap("a").select(Column.keys).unfold().both().groupCount("a").cap("a")
      """
    When iterated to list
    Then the result should be ordered
      | map | {"v[marko]": 6, "v[vadas]": 2, "v[lop]": 6, "v[josh]": 6, "v[ripple]": 2, "v[peter]": 2} |