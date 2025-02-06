import { createClient } from '@supabase/supabase-js';

// Supabase URL & Secret Key
const supabase = createClient(
Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')! // Use Service Role for secure access
);

export async function handler(req: Request) {
  try {
    const today = new Date();
    const threeDaysLater = new Date();
    threeDaysLater.setDate(today.getDate() + 3);

    // Format dates as YYYY-MM-DD
    const todayStr = today.toISOString().split("T")[0];
    const threeDaysLaterStr = threeDaysLater.toISOString().split("T")[0];

    // Fetch due payments
    const { data, error } = await supabase
      .from('installment_payment')
      .select('user_id, due_date, amount')
      .gte('due_date', todayStr)
      .lte('due_date', threeDaysLaterStr);

    if (error) throw error;

    if (data.length === 0) {
      return new Response("No due payments found", { status: 200 });
    }

    for (const payment of data) {
      const dueDate = new Date(payment.due_date);
      const daysLeft = Math.ceil((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));

      // Send notification via Supabase Realtime or Push API
      await sendPushNotification(payment.user_id, `You have ${daysLeft} days left to pay your installment of ${payment.amount}.`);
    }

    return new Response("Notifications sent!", { status: 200 });
  } catch (error) {
    return new Response(`Error: ${error.message}`, { status: 500 });
  }
}

// Simulated push notification function
async function sendPushNotification(userId: string, message: string) {
  console.log(`Sending notification to User ${userId}: ${message}`);
}
