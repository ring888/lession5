import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Text "mo:base/Text";
actor {
    public type Message = {
        author:Text;
        text:Text;
        time:Int;
        };

    public type blog = actor{
        follow: shared(Principal) -> async();
        follows:shared query()->async[Principal];
        post:shared (Text) -> async();
        posts:shared query()->async[Message];
        timeline:shared()->async[Message];
    };

    stable var followed : List.List<Principal> = List.nil();

    public shared func follow(id:Principal):async(){
        followed := List.push(id,followed);
    };

    
    public shared query func follows():async[Principal]{
        List.toArray(followed)
    };

    stable var messages :List.List<Message> = List.nil();
    public shared func get_name():async？Text

    public shared (msg) func post(text:Text):async(){
        assert(Principal.toText(msg.caller) == "piwca-xuaar-clsli-tcj4s-y5756-ufpsb-zxb4u-n64ea-gsyax-7fzif-pqe");
        let author:Text = switch _author {
            case (null) "ring";
            case (?Text) Text;
        }
        let m = {
            author = author;
            text=text;
            time=Time.now()
        };
        
        messages := List.push(m,messages) 
    };

    public shared query func posts(since:Time.Time):async[Message]{
        var all :List.List<Message> = List.nil();
        for(item in Iter.fromList(messages)){
            if(item.time > since)
                all:=List.push(item,all);
        };
        List.toArray(all)
    };

    public shared func timeline(since:Time.Time):async[Message]{
        var all :List.List<Message> = List.nil();
        for(id in Iter.fromList(followed)){
            let canister : blog = actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for(msg in Iter.fromArray(msgs)){
                all :=List.push(msg,all);
            }
        };

        List.toArray(all)
    };
};