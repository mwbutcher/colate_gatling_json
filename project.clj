(defproject colate_gatling_json "0.1.0-SNAPSHOT"
  :description "gatling 2 stats json parser"
  :url "http://na"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [
                 [org.clojure/clojure "1.6.0"]
                 [org.clojure/data.json "0.2.5"]
                 [org.clojure/tools.cli "0.2.4"]
                 [org.clojure/math.combinatorics "0.0.8"]]
  :main colate-gatling-json.core
  :manifest {"Class-Path" "lib/clojure-1.2.0.jar"}
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})




                                        ;:main ^:skip-aot colate-gatling-json.core
