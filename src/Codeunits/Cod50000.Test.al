codeunit 50002 GenJnlLine 

{ 

 
 
 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnBeforeReverse', '', false, false)] 

    local procedure OnBeforeReverse(var IsHandled: Boolean; var ReversalEntry2: Record "Reversal Entry"; var ReversalEntry: Record "Reversal Entry") 

    begin 

        ReversalEntry2."Posting Date" := ReversalEntry."Posting Date"; 

        Message('Posting Date %1 and Posting Date %2', ReversalEntry."Posting Date", ReversalEntry2."Posting Date"); 

    end; 

 
 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseOnBeforeStartPosting', '', false, false)] 

    local procedure OnReverseOnBeforeStartPosting(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var ReversalEntry: Record "Reversal Entry") 

    begin 

        GenJournalLine."Posting Date" := ReversalEntry."Posting Date"; 

        Message('Gne Jn Line Pos %1', GenJournalLine."Posting Date"); 

    end; 

    //OnReverseGLEntryOnBeforeLoop 

 
 
 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeLoop', '', false, false)] 

    local procedure OnReverseGLEntryOnBeforeLoop(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line") 

    begin 

        GLEntry."Posting Date" := GenJournalLine."Posting Date"; 

        Message('Gne Jn Line Pos %1 and gl entry %2', GenJournalLine."Posting Date", GLEntry."Posting Date"); 

    end; 

 
 

    procedure MyProcedure() 

    var 

        myInt: Integer; 

    begin 

 
 

    end; 

 
 

} 

 
 

 pageextension 50000 "reversal entry page" extends "Reverse Entries" 

{ 

    layout 

    { 

        modify("Posting Date") 

        { Editable = true; } 

    } 

} 