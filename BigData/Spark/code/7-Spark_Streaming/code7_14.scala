import java.util.HashMap
import org.apache.kafka.clients.producer.{KafkaProducer, ProducerConfig, ProducerRecord}
object KafkaWordCountProducer {
  def main(args: Array[String]) {
    if (args.length < 4) {
      System.err.println("Usage: KafkaWordCountProducer <metadataBrokerList> <topic> " +
        "<messages> <words>")
      System.exit(1)
    }
    val Array(brokers, topic, messages, words) = args
    // Zookeeper connection properties
    val props = new HashMap[String, Object]()
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers)
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    val producer = new KafkaProducer[String, String](props)
    // Send some messages
    while(true) {
      (1 to messages.toInt).foreach { messageNum =>   //messages锛歂umber of messages generated per second
        val str = (1 to words.toInt).map(x => scala.util.Random.nextInt(10).toString)   //words锛歂umber of words per message
          .mkString(" ")    //Each word range is 0-9
        print(str)
        println()
        val message = new ProducerRecord[String, String](topic, null, str)
        producer.send(message)
      }
      Thread.sleep(1000)  //Time pause for one second
    }
  }
}

