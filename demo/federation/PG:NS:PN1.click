elementclass NetCacheEgress_1_0 {
    $INGRESS_IP, $PORT1, $PORT2 |
    Classifier0 :: Classifier(12/0800, -);
    Align0 :: Align(4, 0);
    Strip0 :: Strip(14);
    CheckIPHeader0 :: CheckIPHeader();
    IPClassifier0 :: IPClassifier(tcp, -);
    NetCacheElement0 :: NetCacheElement(EGRESS);
    Queue0 :: Queue();
    Queue1 :: Queue();
    Socket0 :: Socket(Udp, $INGRESS_IP, $PORT1);
    Socket1 :: Socket(Udp, $INGRESS_IP, $PORT2);
    Unstrip0 :: Unstrip(14);
    Unstrip1 :: Unstrip(14);
    SetIPChecksum0 :: SetIPChecksum();
    Null0 :: Null;

    input -> Classifier0;
    Classifier0 -> Strip0;
    Classifier0[1] -> Null0;
    Strip0 -> Align0;
    Align0 -> CheckIPHeader0;
    CheckIPHeader0 -> IPClassifier0;
    IPClassifier0[1] -> Unstrip0;
    Unstrip0 -> Null0;
    IPClassifier0 -> NetCacheElement0;
    NetCacheElement0 -> SetIPChecksum0;
    SetIPChecksum0 -> Unstrip1;
    Unstrip1 -> Null0;
    NetCacheElement0[1] -> Queue0;
    NetCacheElement0[2] -> Queue1;
    Queue0 -> Socket0;
    Queue1 -> Socket1;
    Null0 -> output;
 } 

FromDevice0 :: FromDevice(vlan327, PROMISC true);
FromDevice1 :: FromDevice(vlan309, PROMISC true);
ToDevice0 :: ToDevice(vlan327);
Queue0 :: Queue();
Queue1 :: Queue();
EtherSwitch0 :: EtherSwitch();
KernelTap0 :: KernelTap(10.1.1.2/24, ETHER 02:b3:12:98:ec:70);
Queue2 :: Queue();
ToDevice1 :: ToDevice(vlan309);
NetCacheEgress0 :: NetCacheEgress_1_0(10.1.1.1, 50000, 50001);

FromDevice1 -> [1]EtherSwitch0;
KernelTap0 -> [2]EtherSwitch0;
EtherSwitch0 -> Queue0;
Queue0 -> ToDevice0;
EtherSwitch0[1] -> Queue1;
EtherSwitch0[2] -> Queue2;
Queue2 -> KernelTap0;
Queue1 -> ToDevice1;
FromDevice0 -> NetCacheEgress0;
NetCacheEgress0 -> EtherSwitch0;
