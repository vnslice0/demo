elementclass NetCacheIngress_1_0 {
    $PORT1, $PORT2 |
    Classifier0 :: Classifier(12/0800, -);
    Strip0 :: Strip(14);
    Align0 :: Align(4, 0);
    CheckIPHeader0 :: CheckIPHeader();
    IPClassifier0 :: IPClassifier(tcp, -);
    NetCacheElement0 :: NetCacheElement(INGRESS);
    IPClassifier1 :: IPClassifier(dst port $PORT1 or $PORT2, -);
    Unstrip0 :: Unstrip(14);
    SetIPChecksum0 :: SetIPChecksum();
    Unstrip1 :: Unstrip(14);
    Null0 :: Null;
    Discard0 :: Discard();
    FromSocket0 :: FromSocket(Udp, 0.0.0.0, $PORT1);
    FromSocket1 :: FromSocket(Udp, 0.0.0.0, $PORT2);

    input -> Classifier0;
    Classifier0[1] -> Null0;
    Classifier0 -> Strip0;
    Strip0 -> Align0;
    Align0 -> CheckIPHeader0;
    CheckIPHeader0 -> IPClassifier0;
    IPClassifier0 -> NetCacheElement0;
    NetCacheElement0 -> IPClassifier1;
    IPClassifier1 -> Discard0;
    IPClassifier0[1] -> Unstrip0;
    Unstrip0 -> Null0;
    IPClassifier1[1] -> SetIPChecksum0;
    SetIPChecksum0 -> Unstrip1;
    Unstrip1 -> Null0;
    FromSocket0 -> [1]NetCacheElement0;
    FromSocket1 -> [2]NetCacheElement0;
    Null0 -> output;
 } 

FromDevice0 :: FromDevice(eth2, PROMISC true);
FromDevice1 :: FromDevice(eth1, PROMISC true);
ToDevice0 :: ToDevice(eth2);
Queue0 :: Queue();
Queue1 :: Queue();
EtherSwitch0 :: EtherSwitch();
ToDevice1 :: ToDevice(eth1);
NetCacheIngress0 :: NetCacheIngress_1_0(50000, 50001);

FromDevice1 -> [1]EtherSwitch0;
EtherSwitch0 -> Queue0;
Queue0 -> ToDevice0;
EtherSwitch0[1] -> Queue1;
Queue1 -> ToDevice1;
FromDevice0 -> NetCacheIngress0;
NetCacheIngress0 -> EtherSwitch0;
